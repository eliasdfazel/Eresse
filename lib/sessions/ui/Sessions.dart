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
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
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
import 'package:Eresse/utils/ui/actions/ElementsActions.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
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
  
  List<DialogueSqlDataStructure> dialogues = [];

  Widget loadingAnimation = LoadingAnimationWidget.dotsTriangle(
      size: 51,
      color: ColorsResources.premiumLight.withAlpha(73)
  );

  double toolbarOpacity = 0;

  DialogueSqlDataStructure? selectedDialogue;

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

    FocusManager.instance.primaryFocus?.unfocus();

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
                      padding: const EdgeInsets.fromLTRB(0, 159, 0, 159),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dialogues.length,
                      itemBuilder: (context, index) {

                        Widget element = Container();

                        switch (dialogues[index].contentTypeIndicator()) {
                          case ContentType.queryType: {

                            element = QueryElement(queryPressed: (data) {

                              selectDialogue(data);

                            }, queryDataStructure: dialogues[index]);

                          }
                          case ContentType.decisionType: {


                            element = DecisionElement(decisionPressed: (data) {

                              selectDialogue(data);

                            }, queryDataStructure: dialogues[index]);

                          }
                          case ContentType.askType: {

                            element = AskElement(askPressed: (data) {

                            }, queryDataStructure: dialogues[index]);

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

                      },
                      inputPressed: () {

                        scrollToEnd(_scrollController);

                      },
                  ),
                  /* END - Actions Bar */

                  /* START - Actions Bar */
                  Toolbar(
                      toolbarOpacity: toolbarOpacity,
                      askPressed: (question) {

                        // Call AI
                        // and Store Answer
                        askingProcess();

                      },
                      archivePressed: (content) {

                        // check for result
                        // archive it with success/failed result
                        archivingProcess();

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

      await _sessionsDI.insertQueries.insertDialogues(_sessionsDI.firebaseUser!, widget.sessionId, contentType, content);

      processLastDialogue(dialogueDataStructure(contentType, content));

    }

  }

  void processDialogues() async {

    if (_sessionsDI.firebaseUser != null) {

      final retrievedDialogues = await _sessionsDI.retrieveQueries.retrieveDialogues(_sessionsDI.firebaseUser!, widget.sessionId);

      if (retrievedDialogues.isEmpty) {

        // Set Initial Session Metadata
        _sessionsDI.insertQueries.insertSessionMetadata(_sessionsDI.firebaseUser!, widget.sessionId, SessionStatus.sessionOpen);

      } else {

        dialogues.clear();

        setState(() {

          dialogues.addAll(retrievedDialogues);

          loadingAnimation = Container();

        });

        scrollToEnd(_scrollController);

        _sessionsDI.insertQueries.updateSessionMetadata(_sessionsDI.firebaseUser!, widget.sessionId);

        //  Summary and Title
        if (dialogues.length >= SessionDataStructure.contextThreshold) {

          updateSessionContext(dialogues);

        }

      }

    }

    setState(() {

      loadingAnimation = Container();

    });

  }

  Future processLastDialogue(Map<String, dynamic> lastDialogue) async {

    setState(() {

      dialogues.add(DialogueSqlDataStructure.fromMap(lastDialogue));

    });

    scrollToEnd(_scrollController);

  }

  Future updateSessionContext(List<DialogueSqlDataStructure> dialogues) async {

    // Send Dialogues To AI and Ask for Summary and Title
    final sessionTitle = 'N/A';
    final sessionSummary = 'N/A';

    _sessionsDI.insertQueries.updateSessionContext(_sessionsDI.firebaseUser!, widget.sessionId, sessionTitle, sessionSummary);

  }

  Future askingProcess() async {

    if (selectedDialogue != null) {

    } else {

    }

  }

  Future archivingProcess() async {

    if (selectedDialogue != null) {

    } else {

    }

  }

  void selectDialogue(DialogueSqlDataStructure dialogueDataStructure) {

    selectedDialogue = dialogueDataStructure;

    setState(() {

      toolbarOpacity = (toolbarOpacity == 1) ? 0 : 1;

    });

  }

}