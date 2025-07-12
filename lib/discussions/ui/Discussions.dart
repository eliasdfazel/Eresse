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
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Discussions extends StatefulWidget {

  bool internetConnection = false;

  Discussions({super.key});

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

                  /* START - Decoration */
                  _networkShield
                  /* END - Decoration */

                ]
            )
        )
    );
  }

  @override
  void networkEnabled() {

    Future.delayed(const Duration(milliseconds: 777), () {

      setState(() {

        _networkShield = _discussionsDI.networking.offlineMode();

      });

    });

  }

  @override
  void networkDisabled() {

    setState(() {

      _networkShield = Container();

    });

  }

}