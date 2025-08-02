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

import 'package:Eresse/dashboard/ui/Dashboard.dart';
import 'package:Eresse/entry/di/EntryDI.dart';
import 'package:Eresse/profile/authentication/Interface/AuthenticationInterface.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Entry extends StatefulWidget {

  const Entry({Key? key}) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();


}
class _EntryState extends State<Entry> implements NetworkInterface, AuthenticationInterface {

  final EntryDI _entryDI = EntryDI();

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

    _entryDI.emailAuthentication.start(this);

    /*
     * Start - Network Listener
     */
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connectivityResults) async {

      _entryDI.networking.networkCheckpoint(this, connectivityResults);

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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorsResources.primaryColor,
        body: Stack(
            children: [

              /* START - Decoration */
              entryDecorations(),
              /* END - Decoration */

              _networkShield

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

        _networkShield = _entryDI.networking.offlineMode();

      });

    });

  }

  @override
  void authenticated(UserCredential userCredential) {


  }

  @override
  void profiled(DocumentSnapshot<Object?> documentSnapshot) {

    navigateTo(context, Dashboard());

  }

}