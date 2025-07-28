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
import 'package:Eresse/dashboard/ui/sections/SessionElement.dart';
import 'package:Eresse/dashboard/ui/sections/SuccessTip.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/sessions/ui/Sessions.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Dashboard extends StatefulWidget {

  Dashboard({super.key});

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

  List<SessionSqlDataStructure> sessions = [];

  Widget loadingAnimation = LoadingAnimationWidget.dotsTriangle(
      size: 51,
      color: ColorsResources.premiumLight.withAlpha(73)
  );

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

    retrieveSessions();

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
                          height: 51,
                          color: Colors.transparent,
                        ),

                        /* END - Session Archive */
                        Padding(
                          padding: EdgeInsets.only(left: 37, right: 37),
                          child: Text(
                            StringsResources.openSessionsTitle().toUpperCase(),
                            style: TextStyle(
                              color: ColorsResources.premiumLight.withAlpha(179),
                              fontSize: 15,
                              letterSpacing: 3.7,
                              fontFamily: 'Anurati'
                            ),
                          )
                        ),

                        Divider(
                          height: 11,
                          color: Colors.transparent,
                        ),

                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {

                              return SessionElement(sessionDataStructure: sessions[index], sessionPressed: (data) {

                                if (_dashboardDI.firebaseUser != null) {

                                  navigateTo(context, Sessions(firebaseUser: _dashboardDI.firebaseUser!, sessionId: data.getSessionId())).then((data) {

                                    retrieveSessions();

                                  });

                                }

                              });
                            }
                        ),
                        /* END - Session Archive */

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
                      top: 51,
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

                  Positioned(
                      top: 51,
                      left: 19,
                      right: 19,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: loadingAnimation
                      )
                  ),

                  /* START - Actions Bar */
                  ActionsBar(
                      startPressed: (_) {

                        if (_dashboardDI.firebaseUser != null) {

                          navigateTo(context, Sessions(firebaseUser: _dashboardDI.firebaseUser!, sessionId: now().toString())).then((data) {

                            retrieveSessions();

                          });

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

  void retrieveSessions() async {

    if (_dashboardDI.firebaseUser != null) {

      final allSessions = await _dashboardDI.retrieveQueries.retrieveSessions(_dashboardDI.firebaseUser!);

      if (allSessions.isNotEmpty) {

        for (final element in allSessions) {

          _dashboardDI.retrieveQueries.cacheDialogues(_dashboardDI.firebaseUser!, element[SessionDataStructure.sessionIdKey]);

          sessions.add(SessionSqlDataStructure.fromMap(element));

        }

        setState(() {

          sessions;

          loadingAnimation = Container();

        });

      }

    }

  }

}