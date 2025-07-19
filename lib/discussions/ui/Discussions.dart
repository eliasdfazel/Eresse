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

import 'package:Eresse/discussions/di/DiscussionsDI.dart';
import 'package:Eresse/discussions/ui/sections/ActionsBar.dart';
import 'package:Eresse/discussions/ui/sections/ToolsBar.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Discussions extends StatefulWidget {

  User firebaseUser;

  Discussions({super.key, required this.firebaseUser});

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
            resizeToAvoidBottomInset: false,
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
                      children: [





                      ]
                  ),
                  /* END - Content */

                  /* START - Back */
                  Positioned(
                      top: 51,
                      left: 19,
                      child: InkWell(
                          onTap: () {

                            navigatePop(context);

                          },
                          child: Image(
                            image: AssetImage("assets/back.png"),
                          )
                      )
                  ),
                  /* END - Back */

                  /* START - Actions Bar */
                  ActionsBar(
                      queryPressed: (_) {



                      },
                      decisionPressed: (_) {

                      }
                  ),
                  /* END - Actions Bar */

                  /* START - Actions Bar */
                  ToolsBar(
                      askPressed: (_) {



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

        _networkShield = _discussionsDI.networking.offlineMode();

      });

    });

  }

}