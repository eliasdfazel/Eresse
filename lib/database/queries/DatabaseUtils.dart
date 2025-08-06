import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtils {

  final SetupDatabase _setupDatabase = SetupDatabase();

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  final dialoguesJSON = DialoguesJSON();

  Future<SessionSqlDataStructure?> rowExists(String sessionId) async {

    Database databaseInstance = await _setupDatabase.initializeDatabase();

    SessionSqlDataStructure? sessionSqlDataStructure;

    final rowsResults = (await databaseInstance.rawQuery('SELECT * FROM ${SessionSqlDataStructure.sessionsTable()} WHERE sessionId = $sessionId'));

    if (rowsResults.isNotEmpty) {

      Map<String, Object?> sessionSqlDataStructureMap = rowsResults.first;

      sessionSqlDataStructure = SessionSqlDataStructure.fromMap(sessionSqlDataStructureMap);

    }

    return sessionSqlDataStructure;
  }

  Future processEmptySession(User firebaseUser, String sessionId) async {

    rowExists(sessionId).then((sessionSqlDataStructure) {

      if (sessionSqlDataStructure != null) {

        dialoguesJSON.retrieveDialogues(sessionSqlDataStructure.getSessionJsonContent()).then((dialogues) {

          if (dialogues.isEmpty) {

            deleteEmptySessions(firebaseUser, sessionId);

          }

        });

      }

    });

  }

  Future deleteEmptySessions(User firebaseUser, String sessionId) async {

    Database databaseInstance = await _setupDatabase.initializeDatabase();

    databaseInstance.delete(
        SessionSqlDataStructure.sessionsTable(),
        where: 'sessionId = ?',
        whereArgs: [sessionId]
    );

    final firestore = FirebaseFirestore.instance;

    firestore.doc(_databaseEndpoints.sessionMetadataDocument(firebaseUser, sessionId)).delete();

    firestore.collection(_databaseEndpoints.sessionContentCollection(firebaseUser, sessionId)).get().then((querySnapshot) {

      for (final DocumentSnapshot documentSnapshot in querySnapshot.docs) {

        documentSnapshot.reference.delete();

      }

    });

  }

}