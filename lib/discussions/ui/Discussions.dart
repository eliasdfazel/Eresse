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

import 'package:Eresse/discussions/data/DialogueDataStructure.dart';
import 'package:Eresse/discussions/di/DiscussionsDI.dart';
import 'package:Eresse/discussions/ui/elements/QueryElement.dart';
import 'package:Eresse/discussions/ui/sections/ActionsBar.dart';
import 'package:Eresse/discussions/ui/sections/Toolbar.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Discussions extends StatefulWidget {

  User firebaseUser;

  String discussionId;

  Discussions({super.key, required this.firebaseUser, required this.discussionId});

  @override
  State<Discussions> createState() => _DiscussionsState();
}
class _DiscussionsState extends State<Discussions> implements NetworkInterface {

  final DiscussionsDI _discussionsDI = DiscussionsDI();

  /*
   * Start - Network Listener
   */
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Widget _networkShield = Container();
  /*
   * End - Network Listener
   */

  List<Widget> itemsWidget = [];


  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    /*
     * Start - Network Listener
     */
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connectivityResults) async {

      _discussionsDI.networking.networkCheckpoint(this, connectivityResults);

    });
    /*
     * End - Network Listener
     */

    processItems();

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
                      padding: const EdgeInsets.fromLTRB(0, 173, 0, 173),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: itemsWidget
                  ),
                  /* END - Content */

                  /* START - Back */
                  Positioned(
                      top: 51,
                      left: 19,
                      child: NextedButtons(
                          buttonTag: "Back",
                          onPressed: (data) {

                            navigatePop(context);

                          },
                          imageResources: "assets/back.png",
                          imageNetwork: false,
                          boxFit: BoxFit.none,
                          paddingInset: 0
                      )
                  ),
                  /* END - Back */

                  /* START - Actions Bar */
                  ActionsBar(
                      queryPressed: (content) {
                        debugPrint('Query: $content');

                        storeContent(ContentType.queryType, content);

                      },
                      decisionPressed: (content) {
                        debugPrint('Decision: $content');

                        storeContent(ContentType.decisionType, content);

                      }
                  ),
                  /* END - Actions Bar */

                  /* START - Actions Bar */
                  Toolbar(
                      askPressed: (question) {

                        // Call AI
                        // and Store Answer

                      },
                      archivePressed: (content) {

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

        _networkShield = _discussionsDI.networking.offlineMode();

      });

    });

  }

  Future storeContent(ContentType contentType, String content) async {

    if (_discussionsDI.firebaseUser != null) {

      FirebaseFirestore.instance.collection(_discussionsDI.databaseEndpoints.discussionContentCollection(_discussionsDI.firebaseUser!, widget.discussionId))
          .add(generate(contentType, content)).then((documentSnapshot) async {

            processLastItem(await documentSnapshot.get());

          });

    }

  }

  Future processItems() async {

    FirebaseFirestore.instance.collection(_discussionsDI.databaseEndpoints.discussionContentCollection(_discussionsDI.firebaseUser!, widget.discussionId))
      .orderBy(DialogueDataStructure.timestampKey, descending: false)
      .get(GetOptions(source: Source.server)).then((querySnapshot) {

        if (querySnapshot.docs.isNotEmpty) {

          for (final element in querySnapshot.docs) {
            print(DialogueDataStructure(element).documentId());

            itemsWidget.add(QueryElement(queryPressed: (data) {}, queryDataStructure: DialogueDataStructure(element)));

          }

          setState(() {

            itemsWidget = itemsWidget;

          });

        }

      });

  }

  Future processLastItem(documentSnapshot) async {

    setState(() {

      itemsWidget.add(QueryElement(queryPressed: (data) {}, queryDataStructure: DialogueDataStructure(documentSnapshot)));

    });

  }

}