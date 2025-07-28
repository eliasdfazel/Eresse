import 'dart:core';

import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sql.dart';

class InsertQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  final SetupDatabase _setupDatabase = SetupDatabase();

  final DialoguesJSON _dialoguesJSON = DialoguesJSON();

  /// content = sessionJsonContent
  Future<SessionSqlDataStructure> insertDialogues(User firebaseUser, String sessionId, ContentType contentType, String content) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      sessionSqlDataStructure.setSessionJsonContent(content);
      sessionSqlDataStructure.setUpdatedTimestamp(now().toString());

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), sessionSqlDataStructure.toMap());

    } else {

      sessionSqlDataStructure = SessionSqlDataStructure(
          sessionId: sessionId,
          createdTimestamp: now().toString(),
          updatedTimestamp: now().toString(),
          sessionTitle: '',
          sessionSummary: '',
          sessionStatus: SessionStatus.sessionOpen.name,
          sessionJsonContent: content
      );

      await databaseInstance.insert(SessionSqlDataStructure.sessionsTable(),
          sessionSqlDataStructure.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

    }

    await _setupDatabase.closeDatabase(databaseInstance);

    return sessionSqlDataStructure;

  }

  Future<DocumentReference> _insertDialogues(User firebaseUser, String sessionId, ContentType contentType, String content) async {

      final documentReference = await FirebaseFirestore.instance.collection(_databaseEndpoints.sessionContentCollection(firebaseUser, sessionId))
          .add(dialogueDataStructure(contentType, content));

      return documentReference;
  }

  Future<dynamic> insertSessionMetadata(User firebaseUser, String sessionId, SessionStatus sessionStatus) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      sessionSqlDataStructure.setSessionStatus(sessionStatus.name);

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), sessionSqlDataStructure.toMap());

    }

    await _setupDatabase.closeDatabase(databaseInstance);

  }

  Future<dynamic> _insertSessionMetadata(User firebaseUser, String sessionId, SessionStatus sessionStatus) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.sessionMetadataDocument(firebaseUser, sessionId))
        .set(sessionMetadata(
          sessionId,
          sessionStatus
    ));

    return resultCallback;
  }

  Future<dynamic> updateSessionMetadata(User firebaseUser, String sessionId) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      sessionSqlDataStructure.setUpdatedTimestamp(now().toString());

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), sessionSqlDataStructure.toMap());

    }

    await _setupDatabase.closeDatabase(databaseInstance);
  }

  Future<dynamic> _updateSessionMetadata(User firebaseUser, String sessionId) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.sessionMetadataDocument(firebaseUser, sessionId))
        .update(sessionUpdateMetadata());

    return resultCallback;
  }

  Future<dynamic> updateSessionContext(User firebaseUser, String sessionId, String sessionTitle, String sessionSummary) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      sessionSqlDataStructure.setSessionTitle(sessionTitle);
      sessionSqlDataStructure.setSessionSummary(sessionSummary);

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), sessionSqlDataStructure.toMap());

    }

    await _setupDatabase.closeDatabase(databaseInstance);

  }

  Future<dynamic> _updateSessionContext(User firebaseUser, String sessionId, String sessionTitle, String sessionSummary) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.sessionMetadataDocument(firebaseUser, sessionId))
        .update(sessionUpdateContext(
          sessionTitle: sessionTitle,
          sessionSummary: sessionSummary
        ));

    return resultCallback;
  }

}