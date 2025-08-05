import 'dart:core';
import 'dart:io';

import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/utils/files/FileIO.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sql.dart';

class InsertQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  final SetupDatabase _setupDatabase = SetupDatabase();

  final DialoguesJSON _dialoguesJSON = DialoguesJSON();

  Future insertSession(User firebaseUser, String sessionId, SessionSqlDataStructure cloudSessionSqlDataStructure) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), cloudSessionSqlDataStructure.toMap());

    } else {

      await databaseInstance.insert(SessionSqlDataStructure.sessionsTable(),
          cloudSessionSqlDataStructure.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

    }

    await _setupDatabase.closeDatabase(databaseInstance);

  }

  Future insertSessionSync(User firebaseUser, String sessionId, SessionSqlDataStructure sessionSqlDataStructure) async {

    await insertSessionMetadataSync(firebaseUser, sessionId, sessionSqlDataStructure.sessionStatusIndicator());

    final localDialogues = await _dialoguesJSON.retrieveDialogues(sessionSqlDataStructure.getSessionJsonContent());

    for (final dialogueElement in localDialogues) {

      insertDialoguesSync(firebaseUser, sessionId, dialogueElement.contentTypeIndicator(), dialogueElement.getContent(), dialogueElement.getTimestamp());

    }

  }

  Future updateSessionElement(User firebaseUser, String sessionId, SessionSqlDataStructure cloudSessionSqlDataStructure) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), cloudSessionSqlDataStructure.toMap());

    }

    await _setupDatabase.closeDatabase(databaseInstance);

  }

  Future updateSessionElementSync(User firebaseUser, String sessionId, SessionSqlDataStructure sessionSqlDataStructure) async {

    await updateSessionMetadataSync(firebaseUser, sessionId);

    final localDialogues = await _dialoguesJSON.retrieveDialogues(sessionSqlDataStructure.getSessionJsonContent());

    for (final dialogueElement in localDialogues) {

      insertDialoguesSync(firebaseUser, sessionId, dialogueElement.contentTypeIndicator(), dialogueElement.getContent(), dialogueElement.getTimestamp());

    }

  }

  /// content = sessionJsonContent
  Future<SessionSqlDataStructure> insertDialogues(User firebaseUser, String sessionId, ContentType contentType, String content, String dialogueId) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      sessionSqlDataStructure.setSessionJsonContent(await _dialoguesJSON.insertDialogueJson(sessionSqlDataStructure.getSessionJsonContent(), contentType, sessionSqlDataStructure.getSessionId(), content));
      sessionSqlDataStructure.setUpdatedTimestamp(now().toString());

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), sessionSqlDataStructure.toMap());

    } else {

      final dialogueId = now().toString();

      sessionSqlDataStructure = SessionSqlDataStructure(
          sessionId: sessionId,
          createdTimestamp: dialogueId,
          updatedTimestamp: now().toString(),
          sessionTitle: 'N/A',
          sessionSummary: 'N/A',
          sessionStatus: SessionStatus.sessionOpen.name,
          sessionJsonContent: await _dialoguesJSON.insertDialogueJson('[]', contentType, now().toString(), content)
      );

      await databaseInstance.insert(SessionSqlDataStructure.sessionsTable(),
          sessionSqlDataStructure.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

    }

    insertDialoguesSync(firebaseUser, sessionId, contentType, content, dialogueId);

    await _setupDatabase.closeDatabase(databaseInstance);

    return sessionSqlDataStructure;

  }

  Future insertDialoguesSync(User firebaseUser, String sessionId, ContentType contentType, String content, String dialogueId) async {

      await FirebaseFirestore.instance.doc(_databaseEndpoints.sessionElementDocument(firebaseUser, sessionId, dialogueId))
          .set(dialogueDataStructure(contentType, dialogueId, content));

  }

  Future<File?> insertImageDialogue(User firebaseUser, String sessionId, ContentType contentType, File imageFile, String dialogueId) async {

    final targetImageFile = await copyImageInternal(imageFile, dialogueId);

    final firebaseStorage = FirebaseStorage.instance.ref().child(_databaseEndpoints.sessionElementImage(firebaseUser, sessionId, dialogueId));

    if (targetImageFile != null) {

      firebaseStorage.putFile(targetImageFile);

    }

    return targetImageFile;
  }

  Future<dynamic> insertSessionMetadata(User firebaseUser, String sessionId, SessionStatus sessionStatus) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _setupDatabase.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      sessionSqlDataStructure.setSessionStatus(sessionStatus.name);

      await databaseInstance.update(SessionSqlDataStructure.sessionsTable(), sessionSqlDataStructure.toMap());

      insertSessionMetadataSync(firebaseUser, sessionId, sessionStatus);

    }

    await _setupDatabase.closeDatabase(databaseInstance);

  }

  Future<dynamic> insertSessionMetadataSync(User firebaseUser, String sessionId, SessionStatus sessionStatus) async {

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

    updateSessionMetadataSync(firebaseUser, sessionId);

    await _setupDatabase.closeDatabase(databaseInstance);
  }

  Future<dynamic> updateSessionMetadataSync(User firebaseUser, String sessionId) async {

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

      updateSessionContextSync(firebaseUser, sessionId, sessionTitle, sessionSummary);

    }

    await _setupDatabase.closeDatabase(databaseInstance);

  }

  Future<dynamic> updateSessionContextSync(User firebaseUser, String sessionId, String sessionTitle, String sessionSummary) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.sessionMetadataDocument(firebaseUser, sessionId))
        .update(sessionUpdateContext(
          sessionTitle: sessionTitle,
          sessionSummary: sessionSummary
        ));

    return resultCallback;
  }

}