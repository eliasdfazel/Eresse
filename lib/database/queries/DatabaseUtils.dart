import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtils {

  final SetupDatabase _setupDatabase = SetupDatabase();

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  final dialoguesJSON = DialoguesJSON();

  Future<SessionSqlDataStructure?> rowExists(Database databaseInstance, String sessionId) async {

    Database databaseInstance = await _setupDatabase.initializeDatabase();

    SessionSqlDataStructure? sessionSqlDataStructure;

    final rowsResults = (await databaseInstance.rawQuery('SELECT * FROM ${SessionSqlDataStructure.sessionsTable()} WHERE sessionId = $sessionId'));

    if (rowsResults.isNotEmpty) {

      Map<String, Object?> sessionSqlDataStructureMap = rowsResults.first;

      sessionSqlDataStructure = SessionSqlDataStructure.fromMap(sessionSqlDataStructureMap);

    }

    return sessionSqlDataStructure;
  }

  Future<SessionSqlDataStructure?> rowExistsById(String sessionId) async {

    Database databaseInstance = await _setupDatabase.initializeDatabase();

    SessionSqlDataStructure? sessionSqlDataStructure;

    final rowsResults = (await databaseInstance.rawQuery('SELECT * FROM ${SessionSqlDataStructure.sessionsTable()} WHERE sessionId = $sessionId'));

    if (rowsResults.isNotEmpty) {

      Map<String, Object?> sessionSqlDataStructureMap = rowsResults.first;

      sessionSqlDataStructure = SessionSqlDataStructure.fromMap(sessionSqlDataStructureMap);

    }

    return sessionSqlDataStructure;
  }

  Future<int> cleanEmptySessions(User firebaseUser, RetrieveQueries retrieveQueries, List<Map<String, dynamic>> allSessions) async {
    debugPrint("Clean Empty Sessions");

    int dataLength = allSessions.length;

    if (allSessions.isNotEmpty) {

      for (final element in allSessions) {

        SessionSqlDataStructure sessionSqlDataStructure = SessionSqlDataStructure.fromMap(element);

        final emptySession = await _processEmptySession(firebaseUser, sessionSqlDataStructure.getSessionId());

        if (emptySession) {

          dataLength = dataLength - 1;

        }

      }

    }

    return dataLength;
  }

  Future<bool> _processEmptySession(User firebaseUser, String sessionId) async {

    final sessionSqlDataStructure = await rowExistsById(sessionId);

    if (sessionSqlDataStructure != null) {

      final dialogues = await dialoguesJSON.retrieveDialogues(sessionSqlDataStructure.getSessionJsonContent());

      if (dialogues.isEmpty) {

        await deleteSessions(firebaseUser, sessionId);

        return true;
      }

    }

    return false;
  }

  Future deleteSessions(User firebaseUser, String sessionId) async {

    Database databaseInstance = await _setupDatabase.initializeDatabase();

    await databaseInstance.delete(
        SessionSqlDataStructure.sessionsTable(),
        where: 'sessionId = ?',
        whereArgs: [sessionId]
    );
    debugPrint("Session $sessionId Deleted");

    final firestore = FirebaseFirestore.instance;

    firestore.doc(_databaseEndpoints.sessionMetadataDocument(firebaseUser, sessionId)).delete();

    firestore.collection(_databaseEndpoints.sessionContentCollection(firebaseUser, sessionId)).get().then((querySnapshot) {

      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {

        documentSnapshot.reference.delete();

      }

    });

  }

}