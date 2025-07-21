/*
 * Copyright © 2023 By Geeks Empire.
 *
 * Created by Elias Fazel
 * Last modified 10/17/23, 7:00 AM
 *
 * Licensed Under MIT License.
 * https://opensource.org/licenses/MIT
 */

import 'dart:io';

import 'package:Eresse/dashboard/ui/Dashboard.dart';
import 'package:Eresse/entry/ui/EntryConfigurations.dart';
import 'package:Eresse/firebase_options.dart';
import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/resources/strings_resources.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  debugPrint("Received: ${remoteMessage.data}");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

}

void main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  var firebaseInitialized = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      webProvider: ReCaptchaV3Provider('6LeNfH0rAAAAAF9xGH-kwf36ABcfPQ9eBDXXHgET'),
      appleProvider: AppleProvider.appAttest,
    );
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      webProvider: ReCaptchaV3Provider('6LeNfH0rAAAAAF9xGH-kwf36ABcfPQ9eBDXXHgET'),
      appleProvider: AppleProvider.deviceCheck,
    );
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final connectivityResults = await (Connectivity().checkConnectivity());

  if (connectivityResults.contains(ConnectivityResult.mobile)
      || connectivityResults.contains(ConnectivityResult.wifi)
      || connectivityResults.contains(ConnectivityResult.vpn)
      || connectivityResults.contains(ConnectivityResult.ethernet)) {

    try {

      FirebaseAuth.instance.currentUser?.reload();

      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

      if (kIsWeb) {

      } else if (Platform.isAndroid
          || Platform.isIOS) {

        firebaseMessaging.subscribeToTopic("Eresse");

      }
      
      Widget entryWidget = EntryConfigurations();

      if (FirebaseAuth.instance.currentUser != null) {
        
        entryWidget = Dashboard();
        
      }
      
      runApp(
          Phoenix(
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: StringsResources.applicationName(),
                  color: ColorsResources.primaryColor,
                  theme: ThemeData(
                    fontFamily: 'Ubuntu',
                    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorsResources.primaryColor),
                    pageTransitionsTheme: const PageTransitionsTheme(builders: {
                      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                    }),
                  ),
                  home: entryWidget
              )
          )
      );

    } on SocketException catch (exception) {
      debugPrint(exception.message);
    }

  }

}