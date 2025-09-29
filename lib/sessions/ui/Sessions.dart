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
import 'package:Eresse/database/utils/DatabaseUtils.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/sessions/di/SessionsDI.dart';
import 'package:Eresse/sessions/ui/elements/AskElement.dart';
import 'package:Eresse/sessions/ui/elements/DecisionElement.dart';
import 'package:Eresse/sessions/ui/elements/QueryElement.dart';
import 'package:Eresse/sessions/ui/sections/ImagePreview.dart';
import 'package:Eresse/sessions/ui/sections/InputsBar.dart';
import 'package:Eresse/sessions/ui/sections/SessionSummary.dart';
import 'package:Eresse/sessions/ui/sections/Toolbar.dart';
import 'package:Eresse/utils/files/ImageSelector.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:Eresse/utils/ui/actions/ElementsActions.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:Eresse/utils/ui/theme/Decorations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Sessions extends StatefulWidget {

  User firebaseUser;

  String sessionId;
  SessionStatus sessionStatus;

  Sessions({super.key, required this.firebaseUser, required this.sessionId, required this.sessionStatus});

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

  double previewOpacity = 0;

  DialogueSqlDataStructure? selectedDialogue;

  String sessionSummary = '';

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    navigatePopWithResult(context, widget.sessionId);

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

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

    BackButtonInterceptor.remove(aInterceptor);

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
              decorations(textureOpacity: 0.13, brandingOpacity: 0.13),
              /* END - Decoration */

              /* START - Content */
              ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(0, 159, 0, 213),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [

                  SessionSummary(
                      content: sessionSummary
                  ),

                  ListView.builder(
                      padding: EdgeInsets.only(top: 51),
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

                        navigatePopWithResult(context, widget.sessionId);

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
                queryPressed: (content) async {
                  debugPrint('Query: $content');

                  final messageContent = await _sessionsDI.dialoguesJSON.messageExtract(content);

                  insertDialogues(ContentType.queryType, messageContent[MessageContent.textMessage.name], messageContent[MessageContent.imageMessage.name]);

                },
                decisionPressed: (content) async {
                  debugPrint('Decision: $content');

                  final messageContent = await _sessionsDI.dialoguesJSON.messageExtract(content);

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
                  askPressed: (question) async {

                    askingProcess(question);

                  },
                  imageSelectorPressed: () async {

                    File? imageFile = await selectImage();

                    if (imageFile != null) {

                      setState(() {

                        imageController = imageFile.path;

                        toolbarOpacity = 0;

                        previewOpacity = 1;

                      });

                      scrollToEnd(_scrollController);

                    }

                  },
                  archivePressed: () async {

                    archivingProcess();

                  },
                  deletePressed: () async {

                    if (_sessionsDI.firebaseUser != null) {

                      await _sessionsDI.databaseUtils.deleteSessions(_sessionsDI.firebaseUser!, widget.sessionId);

                      navigatePopWithResult(context, widget.sessionId);

                    }

                  },
              ),
              /* END - Actions Bar */

              /* START - Selected Image Preview */
              ImagePreview(
                  imageFile: imageController,
                  previewOpacity: previewOpacity,
                  previewPressed: (element) {

                    setState(() {

                      imageController = '';

                      previewOpacity = 0;

                    });

                  }
              ),
              /* END - Selected Image Preview */

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
    print("insert dialogues");

    if (_sessionsDI.firebaseUser != null) {

      final dialogueId = now().toString();

      if (imageMessage != null) {

        final newImageFile = await _sessionsDI.insertQueries.insertImageDialogueSync(_sessionsDI.firebaseUser!, widget.sessionId, contentType, File(imageMessage), dialogueId);

        if (newImageFile != null) {

          imageMessage = newImageFile.path;

        }

      }

      await _sessionsDI.insertQueries.insertDialogues(_sessionsDI.firebaseUser!, widget.sessionId, contentType,
          await _sessionsDI.dialoguesJSON.messageInput(
            textMessage: textMessage,
            imageMessage: imageMessage
          ), dialogueId);

      processLastDialogue(dialogueDataStructure(contentType,
          dialogueId,
          await _sessionsDI.dialoguesJSON.messageInput(
              textMessage: textMessage,
              imageMessage: imageMessage
          )
      ));

    }

  }

  void processDialogues() async {

    print("process Dialogues");

    if (_sessionsDI.firebaseUser != null) {

      final retrievedDialogues = await _sessionsDI.retrieveQueries.retrieveDialogues(_sessionsDI.firebaseUser!, widget.sessionId);

      if (retrievedDialogues.isEmpty) {

        // Set Initial Session Metadata
        _sessionsDI.insertQueries.insertSessionMetadata(_sessionsDI.firebaseUser!, widget.sessionId, SessionStatus.sessionOpen);

      } else {

        setState(() {

          dialogues.clear();

          dialogues.addAll(retrievedDialogues);

          loadingAnimation = Container();

        });

        scrollToStart(_scrollController);

        retrieveSessionSummary();

        _sessionsDI.insertQueries.updateSessionMetadata(_sessionsDI.firebaseUser!, widget.sessionId, widget.sessionStatus);

        //  Summary and Title
        if (await databaseContextThreshold(dialogues.length, _sessionsDI.timesIO)) {

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

      imageController = '';

      toolbarOpacity = 0;

      previewOpacity = 0;

      dialogues.add(DialogueSqlDataStructure.fromMap(lastDialogue));

    });

    scrollToEnd(_scrollController);

  }

  Future updateSessionContext(List<DialogueSqlDataStructure> dialogues) async {

    final dialoguesJsonArray = await _sessionsDI.dialoguesJSON.dialoguesJsonArray(dialogues);

    final generatedSessionTitle = await _sessionsDI.askQuery.analysisSessionTitle(dialoguesJsonArray);
    final generatedSessionSummary = await _sessionsDI.askQuery.analysisSessionSummary(dialoguesJsonArray);

    setState(() {

      sessionSummary = generatedSessionSummary;

    });

    _sessionsDI.insertQueries.updateSessionContext(_sessionsDI.firebaseUser!, widget.sessionId, generatedSessionTitle, sessionSummary);

  }

  Future askingProcess(String inputQuery) async {

    if (_sessionsDI.firebaseUser != null) {

      setState(() {

        loadingAnimation = LoadingAnimationWidget.dotsTriangle(
            size: 51,
            color: ColorsResources.premiumLight.withAlpha(73)
        );

      });

      String textMessage = inputQuery;

      if (selectedDialogue != null) {

        textMessage = (await _sessionsDI.dialoguesJSON.messageExtract(selectedDialogue!.getContent()))[MessageContent.textMessage.name] ?? inputQuery;

      }

      final queryResult = await _sessionsDI.askQuery.retrieveAnswer(textMessage);

      if (queryResult != null) {

        final dialogueId = now().toString();

        await insertDialogues(ContentType.queryType, inputQuery, null);

        await _sessionsDI.insertQueries.insertDialogues(_sessionsDI.firebaseUser!, widget.sessionId, ContentType.askType,
            await _sessionsDI.dialoguesJSON.messageInput(
                textMessage: queryResult,
                imageMessage: null
            ), dialogueId);

        processLastDialogue(dialogueDataStructure(ContentType.askType,
            dialogueId,
            await _sessionsDI.dialoguesJSON.messageInput(
                textMessage: queryResult,
                imageMessage: null
        )));

      }

      setState(() {

        loadingAnimation = Container();

      });

      scrollToEnd(_scrollController);

    }

  }

  Future archivingProcess() async {

    if (_sessionsDI.firebaseUser != null) {

      final dialoguesJsonArray = await _sessionsDI.dialoguesJSON.dialoguesJsonArray(dialogues);

      final bool sessionDecided = await _sessionsDI.askQuery.analysisSessionStatus(dialoguesJsonArray);

      _sessionsDI.insertQueries.updateSessionMetadata(_sessionsDI.firebaseUser!, widget.sessionId, sessionDecided ? SessionStatus.sessionSuccess : SessionStatus.sessionFailed);

      scrollToEnd(_scrollController);

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

        if (sessionSqlDataStructure.getSessionTitle().isNotEmpty
            && !sessionSqlDataStructure.getSessionSummary().contains('N/A')) {

          setState(() {

            sessionSummary = sessionSqlDataStructure.getSessionSummary();

          });

        }

      }

    }

  }

}