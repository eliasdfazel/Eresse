/*
 * Copyright © 2022 By Geeks Empire.
 *
 * Created by Elias Fazel
 * Last modified 12/6/22, 7:22 AM
 *
 * Licensed Under MIT License.
 * https://opensource.org/licenses/MIT
 */

import 'package:Eresse/dashboard/di/DashboardDI.dart';
import 'package:Eresse/dashboard/ui/sections/toolbar/ActionsBar.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:Eresse/utils/ui/elements/NextedButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {

  bool internetConnection = false;

  Dashboard({super.key, required this.internetConnection});

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {

  final DashboardDI _dashboardDI = DashboardDI();

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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

                  /* START - Profile */
                  Positioned(
                    top: 73,
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
                      top: 73,
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

                  ActionsBar(
                      startPressed: (_) {

                      },
                      searchPressed: (_) {

                      },
                      archivePressed: (_) {

                      }
                  )

                ]
            )
        )
    );
  }



}