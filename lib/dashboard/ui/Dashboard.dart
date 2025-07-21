/*
 * Copyright © 2022 By Geeks Empire.
 *
 * Created by Elias Fazel
 * Last modified 12/6/22, 7:22 AM
 *
 * Licensed Under MIT License.
 * https://opensource.org/licenses/MIT
 */

import 'dart:async';

import 'package:Eresse/dashboard/di/DashboardDI.dart';
import 'package:Eresse/dashboard/ui/sections/ActionsBar.dart';
import 'package:Eresse/dashboard/ui/sections/DiscussionElement.dart';
import 'package:Eresse/dashboard/ui/sections/SuccessTip.dart';
import 'package:Eresse/discussions/data/DiscussionDataStructure.dart';
import 'package:Eresse/discussions/ui/Discussions.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {

  bool internetConnection = false;

  Dashboard({super.key, required this.internetConnection});

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> implements NetworkInterface {

  final DashboardDI _dashboardDI = DashboardDI();

  /*
   * Start - Network Listener
   */
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Widget _networkShield = Container();
  /*
   * End - Network Listener
   */

  String successTipContent = '';

  List<DocumentSnapshot> discussions = [];

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    /*
     * Start - Network Listener
     */
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connectivityResults) async {

      _dashboardDI.networking.networkCheckpoint(this, connectivityResults);

    });
    /*
     * End - Network Listener
     */

    retrieveSuccessTip();

    retrieveDiscussions();

  }

  @override
  void dispose() {
    /*
     * Start - Network Listener
     */
    _connectivitySubscription?.cancel();
    /*
     * End - Network Listener
     */
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: StringsResources.applicationName(),
        color: ColorsResources.primaryColor,
        theme: ThemeData(
          fontFamily: 'Ubuntu',
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorsResources.primaryColor),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
          }),
        ),
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: ColorsResources.primaryColor,
            body: Stack(
                children: [

                  /* START - Decoration */
                  decorations(),
                  /* END - Decoration */

                  /* START - Content */
                  ListView(
                      padding: const EdgeInsets.fromLTRB(0, 151, 0, 151),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [

                        SuccessTip(
                          content: successTipContent,
                          successTipPressed: (data) {

                          },
                        ),

                        Divider(
                          height: 37,
                          color: Colors.transparent,
                        ),

                        /* END - Discussion Archive */
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: discussions.length,
                            itemBuilder: (context, index) {

                              DiscussionDataStructure discussionDataStructure = DiscussionDataStructure(discussions[index]);

                              return DiscussionElement(discussionDataStructure: discussionDataStructure, discussionPressed: (data) {

                                if (_dashboardDI.firebaseUser != null) {

                                  navigateTo(context, Discussions(firebaseUser: _dashboardDI.firebaseUser!, discussionId: data.documentId()));

                                }

                              });
                            }
                        ),
                        /* END - Discussion Archive */

                      ]
                  ),

                  /* END - Content */

                  /* START - Profile */
                  Positioned(
                    top: 51,
                    left: 19,
                    child: NextedButtons(
                      buttonTag: "Profile",
                      imageNetwork: true,
                      imageResources: _dashboardDI.firebaseUser!.photoURL.toString(),
                      boxFit: BoxFit.cover,
                      paddingInset: 0,
                      onPressed: (data) {


                      }
                    )
                  ),
                  /* END - Profile */

                  /* START - Preferences */
                  Positioned(
                      top: 73,
                      right: 19,
                      child: NextedButtons(
                          buttonTag: "Preferences",
                          imageNetwork: false,
                          imageResources: "assets/settings.png",
                          boxFit: BoxFit.contain,
                          paddingInset: 5,
                          onPressed: (data) {




                          }
                      )
                  ),
                  /* END - Preferences */

                  /* START - Actions Bar */
                  ActionsBar(
                      startPressed: (_) {

                        if (_dashboardDI.firebaseUser != null) {

                          navigateTo(context, Discussions(firebaseUser: _dashboardDI.firebaseUser!, discussionId: DateTime.now().millisecondsSinceEpoch.toString()));

                        }

                      },
                      searchPressed: (_) {

                      },
                      archivePressed: (_) {

                      }
                  ),
                  /* END - Actions Bar */

                  /* START - Network */
                  _networkShield
                  /* END - Network */

                ]
            )
        )
    );
  }

  @override
  void networkEnabled() {

    setState(() {

      _networkShield = Container();

    });

  }

  @override
  void networkDisabled() {

    Future.delayed(const Duration(milliseconds: 777), () {

      setState(() {

        _networkShield = _dashboardDI.networking.offlineMode();

      });

    });

  }

  void retrieveSuccessTip() async {

    final successTip =  await _dashboardDI.askQuery.retrieveSuccessTips();

    if (successTip != null) {

      setState(() {

        successTipContent = successTip;

      });

    }

  }

  void retrieveDiscussions() {

    if (_dashboardDI.firebaseUser != null) {

      FirebaseFirestore.instance.collection(_dashboardDI.databaseEndpoints.discussionsCollection(_dashboardDI.firebaseUser!))
        .get(GetOptions(source: Source.server)).then((querySnapshot) {

          if (querySnapshot.docs.isNotEmpty) {

            for (final element in querySnapshot.docs) {

              discussions.add(element);

            }

            setState(() {

              discussions;

            });

          }

        });

    }

  }

}