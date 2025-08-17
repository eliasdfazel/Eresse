/*
 * Copyright © 2023 By Geeks Empire.
 *
 * Created by Elias Fazel
 * Last modified 10/3/23, 5:42 AM
 *
 * Licensed Under MIT License.
 * https://opensource.org/licenses/MIT
 */

import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/sessions/ui/Sessions.dart';
import 'package:Eresse/utils/navigations/navigation_commands.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';


class DynamicShortcuts {

  void setup(BuildContext context, RetrieveQueries retrieveQueries, List<Map<String, dynamic>> sessions) async {

    const QuickActions quickActions = QuickActions();

    quickActions.initialize((shortcutType) {
      debugPrint("Shortcut Type: $shortcutType");

      // shortcutType == sessionId
      if (FirebaseAuth.instance.currentUser != null) {

        retrieveQueries.retrieveSession(FirebaseAuth.instance.currentUser!, shortcutType).then((sessionSqlDataStructure) {

          if (sessionSqlDataStructure != null) {

            navigateTo(context, Sessions(firebaseUser: FirebaseAuth.instance.currentUser!, sessionId: shortcutType, sessionStatus: sessionSqlDataStructure.sessionStatusIndicator()));

          }

        });

      }

    });

    quickActions.clearShortcutItems();

    final List<ShortcutItem> dynamicShortcuts = <ShortcutItem>[];

    for (final element in sessions) {

      SessionSqlDataStructure sessionSqlDataStructure = SessionSqlDataStructure.fromMap(element);

      if (sessionSqlDataStructure.sessionStatusIndicator() == SessionStatus.sessionOpen) {

        if (sessionSqlDataStructure.getSessionTitle().isNotEmpty
            && !sessionSqlDataStructure.getSessionTitle().contains('N/A')) {

          dynamicShortcuts.add(ShortcutItem(type: sessionSqlDataStructure.getSessionId(), localizedTitle: sessionSqlDataStructure.getSessionTitle(), icon: 'icon'));

        }

      }

    }

    quickActions.setShortcutItems(dynamicShortcuts);

  }

}