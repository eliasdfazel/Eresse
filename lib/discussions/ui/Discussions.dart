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
import 'package:Eresse/database/structures/DiscussionDataStructure.dart';
import 'package:Eresse/discussions/di/DiscussionsDI.dart';
import 'package:Eresse/discussions/ui/elements/AskElement.dart';
import 'package:Eresse/discussions/ui/elements/DecisionElement.dart';
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
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

      _discussionsDI.networking.networkCheckpoint(this, connectivityResults);

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

        _networkShield = _discussionsDI.networking.offlineMode();

      });

    });

  }

  Future insertDialogues(ContentType contentType, String content) async {

    if (_discussionsDI.firebaseUser != null) {

      final documentReference = await _discussionsDI.insertQueries.insertDialogues(_discussionsDI.firebaseUser!, widget.discussionId, contentType, content);

      print(">>> ${documentReference}");
      // processLastDialogue(await documentReference.get());

    }

  }

  void processDialogues() async {

    if (_discussionsDI.firebaseUser != null) {

      final retrievedDialogues = await _discussionsDI.retrieveQueries.retrieveDialogues(_discussionsDI.firebaseUser!, widget.discussionId);

      if (retrievedDialogues.isEmpty) {

        _discussionsDI.insertQueries.insertDiscussionMetadata(_discussionsDI.firebaseUser!, widget.discussionId);

      } else {

        dialogues.clear();

        setState(() {

          dialogues.addAll(retrievedDialogues);

          loadingAnimation = Container();

        });

        _scrollToEnd();

        _discussionsDI.insertQueries.updateDiscussionMetadata(_discussionsDI.firebaseUser!, widget.discussionId);

        //  Summary and Title
        if (dialogues.length >= DiscussionDataStructure.contextThreshold) {

          updateDiscussionContext(dialogues);

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

  Future updateDiscussionContext(List<DocumentSnapshot> dialogues) async {

    // Send Dialogues To AI and Ask for Summary and Title
    final discussionTitle = '';
    final discussionSummary = '';

    _discussionsDI.insertQueries.updateDiscussionContext(_discussionsDI.firebaseUser!, widget.discussionId, discussionTitle, discussionSummary);

  }

  void _scrollToEnd() {

    Future.delayed(const Duration(milliseconds: 777), () {

      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 137), curve: Curves.easeOut);

    });

  }

}