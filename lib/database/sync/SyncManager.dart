import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/database/sync/di/SyncDI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class Syncing {
  void databaseUpdated();
}

class SyncManager {

  final SyncDI _syncDI = SyncDI();

  Future sync(Syncing syncing, User firebaseUser) async {

    final localSessions = await _syncDI.retrieveQueries.retrieveSessions(firebaseUser);

    final cloudSessions = await _syncDI.retrieveQueries.retrieveSessionsSync(firebaseUser);

    if (localSessions.isEmpty
      && cloudSessions.docs.isNotEmpty) {
      debugPrint('Local Is Empty - Update Local Database');

      await _updateLocalDatabase(cloudSessions, firebaseUser);

      syncing.databaseUpdated();

    } else {

      if (cloudSessions.docs.isEmpty) {
        debugPrint('Cloud Is Empty - Update Cloud Database');

        _updateCloudDatabase(localSessions, firebaseUser);

      } else {
        debugPrint('Local/Cloud Merging');

        _mergeDatabase(syncing, localSessions, cloudSessions, firebaseUser);

      }

    }

  }

  Future _updateLocalDatabase(QuerySnapshot cloudSessions, User firebaseUser) async {

    for (final elementSession in cloudSessions.docs) {

      if (elementSession.exists) {

        final dialoguesSessions = await _syncDI.retrieveQueries.retrieveDialoguesSync(firebaseUser, elementSession.id);

        if (dialoguesSessions.isNotEmpty) {

          final dialoguesJsonArray = await _syncDI.dialoguesJSON.documentsToJson(dialoguesSessions);

          await _syncDI.insertQueries.insertSession(firebaseUser, elementSession.id, SessionSqlDataStructure.fromMapSync(elementSession.data() as Map<String, dynamic>, dialoguesJsonArray));

          _syncDI.retrieveQueries.retrieveSessionImages(firebaseUser, elementSession.id);

        }

      }

    }

  }

  Future _updateCloudDatabase(List<Map<String, dynamic>> localSessions, User firebaseUser) async {

    for (final element in localSessions) {

      SessionSqlDataStructure sessionSqlDataStructure = SessionSqlDataStructure.fromMap(element);

      await _syncDI.insertQueries.insertSessionSync(firebaseUser, sessionSqlDataStructure.getSessionId(), sessionSqlDataStructure);

    }

  }

  Future _mergeDatabase(Syncing syncing, List<Map<String, dynamic>> localSessions, QuerySnapshot<Object?> cloudSessions, User firebaseUser) async {

    if (localSessions.length >= cloudSessions.size) {
      debugPrint('Merging');

      for (final element in localSessions) {

        final sessionSqlDataStructure = SessionSqlDataStructure.fromMap(element);

        final cloudSession = cloudSessions.docs.firstWhere((documentSnapshot) => SessionDataStructure(documentSnapshot).sessionId() == sessionSqlDataStructure.getSessionId());

        final sessionDataStructure = SessionDataStructure(cloudSession);

        if (cloudSession.exists) {

          if (sessionSqlDataStructure.getUpdateTimestamp() > sessionDataStructure.updatedTimestamp()) {
            debugPrint('Merging: Update Cloud Database');

            _syncDI.insertQueries.updateSessionElementSync(firebaseUser, sessionSqlDataStructure.getSessionId(), sessionSqlDataStructure);

          } else if (sessionSqlDataStructure.getUpdateTimestamp() < sessionDataStructure.updatedTimestamp()) {
            debugPrint('Merging: Update Local Database');

            final dialoguesSessions = await _syncDI.retrieveQueries.retrieveDialoguesSync(firebaseUser, sessionDataStructure.sessionId());

            final dialoguesJsonArray = await _syncDI.dialoguesJSON.documentsToJson(dialoguesSessions);

            await _syncDI.insertQueries.updateSessionElement(firebaseUser, cloudSession.id, SessionSqlDataStructure.fromMapSync(cloudSession.data() as Map<String, dynamic>, dialoguesJsonArray));

          }

        } else {

          _syncDI.insertQueries.insertSessionSync(firebaseUser, sessionSqlDataStructure.getSessionId(), sessionSqlDataStructure);

        }

      }

    } else if (localSessions.length < cloudSessions.size) {
      debugPrint('Merging');

      for (final element in cloudSessions.docs) {

        if (element.exists) {

          final sessionDataStructure = SessionDataStructure(element);

          final dialoguesSessions = await _syncDI.retrieveQueries.retrieveDialoguesSync(firebaseUser, element.id);

          if (dialoguesSessions.isNotEmpty) {

            final dialoguesJsonArray = await _syncDI.dialoguesJSON.documentsToJson(dialoguesSessions);

            final databaseInstance = await _syncDI.setupDatabase.initializeDatabase();

            var sessionSqlDataStructure = await _syncDI.databaseUtils.rowExists(databaseInstance, sessionDataStructure.sessionId());

            if (sessionSqlDataStructure != null) {

              if (sessionSqlDataStructure.getUpdateTimestamp() > sessionDataStructure.updatedTimestamp()) {
                debugPrint('Merging: Update Cloud Database');

                _syncDI.insertQueries.updateSessionElementSync(firebaseUser, sessionSqlDataStructure.getSessionId(), sessionSqlDataStructure);

              } else if (sessionSqlDataStructure.getUpdateTimestamp() < sessionDataStructure.updatedTimestamp()) {
                debugPrint('Merging: Update Local Database');

                final dialoguesSessions = await _syncDI.retrieveQueries.retrieveDialoguesSync(firebaseUser, sessionDataStructure.sessionId());

                final dialoguesJsonArray = await _syncDI.dialoguesJSON.documentsToJson(dialoguesSessions);

                await _syncDI.insertQueries.updateSessionElement(firebaseUser, element.id, SessionSqlDataStructure.fromMapSync(element.data() as Map<String, dynamic>, dialoguesJsonArray));

              }

            } else {

              _syncDI.insertQueries.insertSession(firebaseUser, sessionDataStructure.sessionId(), SessionSqlDataStructure.fromMapSync(element.data() as Map<String, dynamic>, dialoguesJsonArray));

            }

          }

        }

        syncing.databaseUpdated();

      }

    }

  }

}