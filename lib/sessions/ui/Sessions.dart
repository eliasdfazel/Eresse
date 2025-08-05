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
import 'dart:io';

import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/sessions/di/SessionsDI.dart';
import 'package:Eresse/sessions/ui/elements/AskElement.dart';
import 'package:Eresse/sessions/ui/elements/DecisionElement.dart';
import 'package:Eresse/sessions/ui/elements/QueryElement.dart';
import 'package:Eresse/sessions/ui/sections/InputsBar.dart';
import 'package:Eresse/sessions/ui/sections/SessionSummary.dart';
import 'package:Eresse/sessions/ui/sections/Toolbar.dart';
import 'package:Eresse/utils/files/ImageSelector.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
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

  TextEditingController textController = TextEditingController();
  String imageController = '';

  DialogueSqlDataStructure? selectedDialogue;

  String sessionSummary = '';

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

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorsResources.black,
        body: Stack(
            children: [

              /* START - Decoration */
              decorations(backgroundOpacity: 0.37, brandingOpacity: 0.37),
              /* END - Decoration */

              /* START - Content */
              ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(0, 159, 0, 159),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [

                  SessionSummary(
                      content: sessionSummary
                  ),

                  Divider(
                    height: 51,
                    color: Colors.transparent,
                  ),

                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dialogues.length,
                      itemBuilder: (context, index) {

                        Widget element = Container();

                        switch (dialogues[index].contentTypeIndicator()) {
                          case ContentType.queryType: {

                            element = QueryElement(dialoguesJSON: _sessionsDI.dialoguesJSON, queryPressed: (data) {

                              selectDialogue(data);

                            }, queryDataStructure: dialogues[index]);

                          }
                          case ContentType.decisionType: {


                            element = DecisionElement(dialoguesJSON: _sessionsDI.dialoguesJSON, decisionPressed: (data) {

                              selectDialogue(data);

                            }, queryDataStructure: dialogues[index]);

                          }
                          case ContentType.askType: {

                            element = AskElement(dialoguesJSON: _sessionsDI.dialoguesJSON, askPressed: (data) {

                            }, queryDataStructure: dialogues[index]);

                          }
                        }

                        return element;
                      }
                  )

                ]
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
              InputsBar(
                dialoguesJSON: _sessionsDI.dialoguesJSON,
                textController: textController,
                imageController: imageController,
                queryPressed: (content) {
                  debugPrint('Query: $content');

                  final messageContent = _sessionsDI.dialoguesJSON.messageMap(content);

                  insertDialogues(ContentType.queryType, messageContent[MessageContent.textMessage.name], messageContent[MessageContent.imageMessage.name]);

                },
                decisionPressed: (content) {
                  debugPrint('Decision: $content');

                  final messageContent = _sessionsDI.dialoguesJSON.messageMap(content);

                  insertDialogues(ContentType.decisionType, messageContent[MessageContent.textMessage.name], messageContent[MessageContent.imageMessage.name]);

                },
                inputPressed: () {

                  scrollToEnd(_scrollController);

                },
              ),
              /* END - Actions Bar */

              /* START - Actions Bar */
              Toolbar(
                  textController: textController,
                  toolbarOpacity: toolbarOpacity,
                  askPressed: (question) {

                    if (textController.text.isNotEmpty) {

                      askingProcess(question);

                    }

                  },
                  imageSelectorPressed: () async {

                    File? imageFile = await selectImage();

                    if (imageFile != null) {

                      // show preview
                      imageController = imageFile.path;

                    }

                  },
                  archivePressed: () {

                    archivingProcess();

                  }
              ),
              /* END - Actions Bar */

              /* START - Network */
              _networkShield
              /* END - Network */

            ]
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

  Future insertDialogues(ContentType contentType, String? textMessage, String? imageMessage) async {

    if (_sessionsDI.firebaseUser != null) {

      await _sessionsDI.insertQueries.insertDialogues(_sessionsDI.firebaseUser!, widget.sessionId, contentType,
          _sessionsDI.dialoguesJSON.messageJson(
            textMessage: textMessage,
            imageMessage: imageMessage
          ));

      processLastDialogue(dialogueDataStructure(contentType,
          now().toString(),
          _sessionsDI.dialoguesJSON.messageJson(
              textMessage: textMessage,
              imageMessage: imageMessage
          )
      ));

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

        retrieveSessionSummary();

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

      textController.text = '';

      toolbarOpacity = 0;

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

  Future askingProcess(String inputQuery) async {

    if (_sessionsDI.firebaseUser != null) {
      debugPrint('Input Query: $inputQuery');

      setState(() {

        loadingAnimation = LoadingAnimationWidget.dotsTriangle(
            size: 51,
            color: ColorsResources.premiumLight.withAlpha(73)
        );

      });

      final queryResult = await _sessionsDI.askQuery.retrieveAnswer((selectedDialogue != null) ? selectedDialogue!.getContent() : inputQuery);

      if (queryResult != null) {

        await insertDialogues(ContentType.queryType, inputQuery, null);

        await _sessionsDI.insertQueries.insertDialogues(_sessionsDI.firebaseUser!, widget.sessionId, ContentType.askType, queryResult);

        processLastDialogue(dialogueDataStructure(ContentType.askType, _sessionsDI.dialoguesJSON.messageJson(
            textMessage: queryResult,
            imageMessage: null
        ), now().toString()));

      }

      setState(() {

        loadingAnimation = Container();

      });

    }

  }

  Future archivingProcess() async {


    // check for result
    // archive it with success/failed result

    if (selectedDialogue != null) {

    } else {

    }

  }

  Future selectDialogue(DialogueSqlDataStructure dialogueDataStructure) async {

    selectedDialogue = dialogueDataStructure;

    setState(() {

      toolbarOpacity = 1;

    });

  }

  Future retrieveSessionSummary() async {

    if (_sessionsDI.firebaseUser != null) {

      final sessionSqlDataStructure = await _sessionsDI.retrieveQueries.retrieveSession(_sessionsDI.firebaseUser!, widget.sessionId);

      if (sessionSqlDataStructure != null) {

        if (sessionSqlDataStructure.sessionStatusIndicator() == SessionStatus.sessionOpen) {

          scrollToEnd(_scrollController);

        }

        setState(() {

          sessionSummary = sessionSqlDataStructure.getSessionSummary();

        });

      } else {



      }

    }

  }

}