/*
 * Copyright © 2022 By Geeks Empire.
 *
 * Created by Elias Fazel
 * Last modified 12/6/22, 7:22 AM
 *
 * Licensed Under MIT License.
 * https://opensource.org/licenses/MIT
 */

import 'package:Eresse/entry/di/EntryDI.dart';
import 'package:Eresse/profile/authentication/Interface/AuthenticationInterface.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:Eresse/utils/ui/Decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntryConfigurations extends StatefulWidget {

  bool internetConnection = false;

  EntryConfigurations({Key? key, required this.internetConnection}) : super(key: key);

  @override
  State<EntryConfigurations> createState() => _EntryConfigurationsState();


}
class _EntryConfigurationsState extends State<EntryConfigurations> implements AuthenticationInterface {

  final EntryDI _entryDI = EntryDI();

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _entryDI.emailAuthentication.start(this);

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
                  entryDecorations(),
                  /* END - Decoration */

                ]
            )
        )
    );
  }

  @override
  void authenticated(UserCredential userCredential) {


  }

  @override
  void profiled(DocumentSnapshot<Object?> documentSnapshot) {


  }

}