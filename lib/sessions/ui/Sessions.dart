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

import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/sessions/di/SessionsDI.dart';
import 'package:Eresse/sessions/ui/elements/AskElement.dart';
import 'package:Eresse/sessions/ui/elements/DecisionElement.dart';
import 'package:Eresse/sessions/ui/elements/QueryElement.dart';
import 'package:Eresse/sessions/ui/sections/ActionsBar.dart';
import 'package:Eresse/sessions/ui/sections/Toolbar.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Sessions extends StatefulWidget {

  User firebaseUser;

  String sessionId;

  Sessions({super.key, required this.firebaseUser, required this.sessionId});

  @override
  State<Sessions> createState() => _SessionsState();
}
class _SessionsState extends State<Sessions> implements NetworkInterface {

  final SessionsDI _sessionsDI = SessionsDI();

  /*
   * Start - Network Listener
   */
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Widget _networkShield = Container();
  /*
   * End - Network Listener
   */

  final _scrollController = ScrollController();
  
  List<DocumentSnapshot> dialogues = [];

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

      _sessionsDI.networking.networkCheckpoint(this, connectivityResults);

    });
    /*
     * End - Network Listener
     */

    processDialogues();

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
                  ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(0, 151, 0, 151),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dialogues.length,
                      itemBuilder: (context, index) {

                        DialogueDataStructure dialogueDataStructure = DialogueDataStructure(dialogues[index]);

                        Widget element = Container();

                        switch (dialogueDataStructure.contentType()) {
                          case ContentType.queryType: {

                            element = QueryElement(queryPressed: (data) {}, queryDataStructure: dialogueDataStructure);

                          }
                          case ContentType.decisionType: {

                            element = DecisionElement(decisionPressed: (data) {}, queryDataStructure: dialogueDataStructure);

                          }
                          case ContentType.askType: {

                            element = AskElement(askPressed: (data) {}, queryDataStructure: dialogueDataStructure);

                          }
                        }

                        return element;
                      }
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
                      queryPressed: (content) {
                        debugPrint('Query: $content');

                        insertDialogues(ContentType.queryType, content);

                      },
                      decisionPressed: (content) {
                        debugPrint('Decision: $content');

                        insertDialogues(ContentType.decisionType, content);

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

        _networkShield = _sessionsDI.networking.offlineMode();

      });

    });

  }

  Future insertDialogues(ContentType contentType, String content) async {

    if (_sessionsDI.firebaseUser != null) {

      final documentReference = await _sessionsDI.insertQueries.insertDialogues(_sessionsDI.firebaseUser!, widget.sessionId, contentType, content);

      // processLastDialogue(await documentReference.get());

    }

  }

  void processDialogues() async {

    if (_sessionsDI.firebaseUser != null) {

      final retrievedDialogues = await _sessionsDI.retrieveQueries.retrieveDialogues(_sessionsDI.firebaseUser!, widget.sessionId);

      if (retrievedDialogues.isEmpty) {

        _sessionsDI.insertQueries.insertSessionMetadata(_sessionsDI.firebaseUser!, widget.sessionId);

      } else {

        dialogues.clear();

        setState(() {

          dialogues.addAll(retrievedDialogues);

          loadingAnimation = Container();

        });

        _scrollToEnd();

        _sessionsDI.insertQueries.updateSessionMetadata(_sessionsDI.firebaseUser!, widget.sessionId);

        //  Summary and Title
        if (dialogues.length >= SessionDataStructure.contextThreshold) {

          updateSessionContext(dialogues);

        }

      }

    }

  }

  Future processLastDialogue(DocumentSnapshot documentSnapshot) async {

    setState(() {

      dialogues.add(documentSnapshot);

    });

    _scrollToEnd();

  }

  Future updateSessionContext(List<DocumentSnapshot> dialogues) async {

    // Send Dialogues To AI and Ask for Summary and Title
    final sessionTitle = '';
    final sessionSummary = '';

    _sessionsDI.insertQueries.updateSessionContext(_sessionsDI.firebaseUser!, widget.sessionId, sessionTitle, sessionSummary);

  }

  void _scrollToEnd() {

    Future.delayed(const Duration(milliseconds: 777), () {

      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 137), curve: Curves.easeOut);

    });

  }

}