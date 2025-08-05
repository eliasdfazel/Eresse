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

import 'package:Eresse/dashboard/di/DashboardDI.dart';
import 'package:Eresse/dashboard/ui/sections/ActionsBar.dart';
import 'package:Eresse/dashboard/ui/sections/SessionElement.dart';
import 'package:Eresse/dashboard/ui/sections/SuccessTip.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/database/sync/SyncManager.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/sessions/ui/Sessions.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:Eresse/utils/ui/decorations/Decorations.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Dashboard extends StatefulWidget {

  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> with TickerProviderStateMixin implements NetworkInterface, Syncing {

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

  /*
   * Start - Receive Shared Text
   */
  static const platform = MethodChannel('app.channel.shared.data');
  String sharedData = '';
  /*
   * End - Receive Shared Text
   */

  String successTipContent = '';

  List<SessionSqlDataStructure> sessions = [];

  Widget loadingAnimation = LoadingAnimationWidget.dotsTriangle(
      size: 51,
      color: ColorsResources.premiumLight.withAlpha(73)
  );

  late AnimationController _animationController;
  late AnimationController _animationControllerCenter;

  late Animation<Color?> tipColorAnimation;
  late Animation<Color?> tipCenterColorAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    /*
     * Start - Receive Shared Text
     */
    receiveSharedText();
    /*
     * End - Receive Shared Text
     */

    /*
     * Start - Network Listener
     */
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connectivityResults) async {

      _dashboardDI.networking.networkCheckpoint(this, connectivityResults);

    });
    /*
     * End - Network Listener
     */

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1579),
      vsync: this
    );

    _animationControllerCenter = AnimationController(
      duration: const Duration(milliseconds: 1579),
      vsync: this
    );

    tipColorAnimation = ColorTween(begin: ColorsResources.premiumDark.withAlpha(137), end: ColorsResources.premiumLight.withAlpha(137)).animate(_animationController);
    tipCenterColorAnimation = ColorTween(begin: Colors.transparent, end: Colors.transparent).animate(_animationControllerCenter);

    retrieveSuccessTip();

    retrieveSessions();

    if (_dashboardDI.firebaseUser != null) {

      _dashboardDI.syncManager.sync(this, _dashboardDI.firebaseUser!);

    }

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

    _animationController.dispose();
    _animationControllerCenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorsResources.primaryColor,
        body: Stack(
            children: [

              /* START - Decoration */
              decorations(),
              /* END - Decoration */

              /* START - Content */
              ListView(
                  padding: const EdgeInsets.fromLTRB(0, 159, 0, 159),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [

                    SuccessTip(
                      topLeftColor: tipColorAnimation.value ?? ColorsResources.premiumDark.withAlpha(137),
                      centerColor: tipCenterColorAnimation.value ?? Colors.transparent,
                      bottomRightColor: tipColorAnimation.value ?? ColorsResources.premiumDark.withAlpha(137),
                      content: successTipContent,
                      successTipPressed: (data) {

                      },
                    ),

                    Divider(
                      height: 51,
                      color: Colors.transparent,
                    ),

                    /* END - Session Archive */
                    Padding(
                        padding: EdgeInsets.only(left: 37, right: 37),
                        child: Text(
                          StringsResources.openSessionsTitle().toUpperCase(),
                          style: TextStyle(
                              color: ColorsResources.premiumLight.withAlpha(179),
                              fontSize: 15,
                              letterSpacing: 3.7,
                              fontFamily: 'Anurati'
                          ),
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

                              navigateTo(context, Sessions(firebaseUser: _dashboardDI.firebaseUser!, sessionId: data.getSessionId())).then((data) {

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

              /* START - Profile */
              Positioned(
                  top: 51,
                  left: 19,
                  child: NextedButtons(
                      buttonTag: "Profile",
                      imageNetwork: true,
                      imageResources: _dashboardDI.firebaseUser!.photoURL.toString(),
                      boxFit: BoxFit.cover,
                      paddingInset: 0,
                      onPressed: (data) {


                      }
                  )
              ),
              /* END - Profile */

              /* START - Preferences */
              Positioned(
                  top: 51,
                  right: 19,
                  child: NextedButtons(
                      buttonTag: "Preferences",
                      imageNetwork: false,
                      imageResources: "assets/settings.png",
                      boxFit: BoxFit.contain,
                      paddingInset: 5,
                      onPressed: (data) {




                      }
                  )
              ),
              /* END - Preferences */

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
                  startPressed: (_) {

                    if (_dashboardDI.firebaseUser != null) {

                      navigateTo(context, Sessions(firebaseUser: _dashboardDI.firebaseUser!, sessionId: now().toString())).then((data) {
                        debugPrint('Session Id: $data');

                        retrieveSessions();

                      });

                    }

                  },
                  searchPressed: (_) {

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
    );
  }

  @override
  void networkEnabled() {
    debugPrint('Network Enabled');

    setState(() {

      _networkShield = Container();

    });

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

  @override
  void databaseUpdated() {
    debugPrint('Local Database Updated');

    retrieveSessions();

  }

  void retrieveSuccessTip() async {

    final successTip =  await _dashboardDI.askQuery.retrieveSuccessTips();

    if (successTip != null) {

      setState(() {

        successTipContent = successTip;

        tipCenterColorAnimation = ColorTween(begin: ColorsResources.premiumLight.withAlpha(199), end: Colors.transparent).animate(_animationControllerCenter);

      });

      tipColorAnimation.addListener(() {
        setState(() {});
      });

      tipCenterColorAnimation.addListener(() {
        setState(() {});
      });

      _animationController.forward();
      _animationControllerCenter.forward();

    }

  }

  void retrieveSessions() async {

    if (_dashboardDI.firebaseUser != null) {

      final allSessions = await _dashboardDI.retrieveQueries.retrieveSessions(_dashboardDI.firebaseUser!);

      if (allSessions.isNotEmpty) {

        sessions.clear();

        int endIndex = 7;

        if (allSessions.length <= 7) {

          endIndex = allSessions.length;

        }

        for (final element in allSessions.sublist(0, endIndex)) {

          SessionSqlDataStructure sessionSqlDataStructure = SessionSqlDataStructure.fromMap(element);

          _dashboardDI.retrieveQueries.cacheDialogues(_dashboardDI.firebaseUser!, sessionSqlDataStructure.sessionId);

          if (sessionSqlDataStructure.sessionStatusIndicator() == SessionStatus.sessionOpen) {

            sessions.add(SessionSqlDataStructure.fromMap(element));

          }

        }

        setState(() {

          sessions;

          loadingAnimation = Container();

        });

      }

    }

  }

  /*
   * Start - Receive Shared Text
   */
  Future<void> receiveSharedText() async {

    var sharedData = await platform.invokeMethod('receiveSharedText');

    if (sharedData != null) {

      setState(() {

        this.sharedData = sharedData as String;

      });

    }
  }
  /*
   * End - Receive Shared Text
   */

}