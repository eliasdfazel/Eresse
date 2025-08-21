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

import 'package:Eresse/arwen/endpoints/ArwenEndpoints.dart';
import 'package:Eresse/dashboard/di/DashboardDI.dart';
import 'package:Eresse/dashboard/ui/sections/SessionElement.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/sessions/ui/Sessions.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:Eresse/utils/ui/theme/Decorations.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Archive extends StatefulWidget {

  Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}
class _ArchiveState extends State<Archive> with TickerProviderStateMixin implements NetworkInterface {

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

  List<SessionSqlDataStructure> sessions = [];

  Widget loadingAnimation = LoadingAnimationWidget.dotsTriangle(
      size: 51,
      color: ColorsResources.premiumLight.withAlpha(73)
  );

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    navigatePopWithResult(context, true);

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

      _dashboardDI.networking.networkCheckpoint(this, connectivityResults);

    });
    /*
     * End - Network Listener
     */

    retrieveSessions();

  }

  @override
  void dispose() {

    BackButtonInterceptor.remove(aInterceptor);

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
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorsResources.black,
        body: Stack(
            children: [

              /* START - Decoration */
              decorations(textureOpacity: 0.19, brandingOpacity: 0.19),
              /* END - Decoration */

              /* START - Content */
              ListView(
                  padding: const EdgeInsets.fromLTRB(0, 159, 0, 159),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [

                    /* END - Session Archive */
                    Visibility(
                      visible: (sessions.isEmpty) ? false : true,
                      child: Padding(
                          padding: EdgeInsets.only(left: 37, right: 37),
                          child: Text(
                            StringsResources.archivesTitle().toUpperCase(),
                            style: TextStyle(
                                color: ColorsResources.premiumLight.withAlpha(179),
                                fontSize: 15,
                                letterSpacing: 3.7,
                                fontFamily: 'Anurati'
                            ),
                          )
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

                              navigateTo(context, Sessions(firebaseUser: _dashboardDI.firebaseUser!, sessionId: data.getSessionId(), sessionStatus: data.sessionStatusIndicator())).then((data) {

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

              /* START - Network */
              _networkShield
              /* END - Network */

            ]
        )
    );
  }

  @override
  void networkEnabled() {
    debugPrint('Network Enabled');

    setState(() {

      _networkShield = Container();

    });

    _dashboardDI.credentialsIO.generateApiKey();

    _dashboardDI.credentialsIO.cipherKeyPhrase();

    _dashboardDI.arwenEndpoints.retrieveEndpoint(ArwenEndpoints.aiTextEndpoint);

  }

  @override
  void networkDisabled() {
    debugPrint('Network Disabled');

    Future.delayed(const Duration(milliseconds: 777), () {

      setState(() {

        _networkShield = _dashboardDI.networking.offlineMode();

      });

    });

  }

  void retrieveSessions() async {

    if (_dashboardDI.firebaseUser != null) {

      final allSessions = await _dashboardDI.retrieveQueries.retrieveSessions(_dashboardDI.firebaseUser!);

      if (allSessions.isNotEmpty) {

        sessions.clear();

        for (final element in allSessions) {

          SessionSqlDataStructure sessionSqlDataStructure = SessionSqlDataStructure.fromMap(element);

          _dashboardDI.retrieveQueries.cacheDialogues(_dashboardDI.firebaseUser!, sessionSqlDataStructure.sessionId);

          if (sessionSqlDataStructure.sessionStatusIndicator() != SessionStatus.sessionOpen) {

            sessions.add(SessionSqlDataStructure.fromMap(element));

          }

        }

        setState(() {

          sessions;

        });

      }

      setState(() {

        loadingAnimation = Container();

      });

    }

  }

}