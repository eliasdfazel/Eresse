import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/queries/InsertQueries.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Syncing {
  void databaseUpdated();
}

class SyncManager {
  
  final RetrieveQueries _retrieveQueries = RetrieveQueries();

  final InsertQueries _insertQueries = InsertQueries();

  final DialoguesJSON _dialoguesJSON = DialoguesJSON();

  Future sync(Syncing syncing, User firebaseUser) async {

    final localSessions = await _retrieveQueries.retrieveSessions(firebaseUser);

    if (localSessions.isEmpty) {

      final cloudSessions = await _retrieveQueries.retrieveSessionsSync(firebaseUser);

      if (cloudSessions.docs.isNotEmpty) {

        await _updateLocalDatabase(cloudSessions, firebaseUser);

      }

    } else {



    }
    /* at the first check emptiness
      * if local empty then check backup
      *
      * if local not empty check timestamp of each sessions
      * update sessions accordingly */


    // if local database updated
    // syncing.databaseUpdated();

  }

  Future _updateLocalDatabase(QuerySnapshot cloudSessions, User firebaseUser) async {

    for (final elementSession in cloudSessions.docs) {

      if (elementSession.exists) {

        final dialoguesSessions = await _retrieveQueries.retrieveDialoguesSync(firebaseUser, elementSession.id);

        if (dialoguesSessions.isNotEmpty) {

          final dialoguesJsonArray = await _dialoguesJSON.documentsToJson(dialoguesSessions);

          await _insertQueries.insertSession(firebaseUser, elementSession.id, SessionSqlDataStructure.fromMapSync(elementSession.data() as Map<String, dynamic>, dialoguesJsonArray));

        }

      }

    }

  }

}