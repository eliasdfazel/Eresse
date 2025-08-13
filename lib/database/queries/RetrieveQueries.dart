import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart' show DialoguesJSON;
import 'package:Eresse/database/queries/DatabaseUtils.dart';
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DialogueSqlDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:Eresse/utils/files/FileIO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RetrieveQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  final SetupDatabase _setupDatabase = SetupDatabase();

  final DatabaseUtils _databaseUtils = DatabaseUtils();

  final DialoguesJSON _dialoguesJSON = DialoguesJSON();

  Future<SessionSqlDataStructure?> retrieveSession(User firebaseUser, String sessionId) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _databaseUtils.rowExists(databaseInstance, sessionId);

    return sessionSqlDataStructure;
  }

  Future<List<Map<String, dynamic>>> retrieveSessions(User firebaseUser) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    final List<Map<String, dynamic>> allSessions = await databaseInstance.query(SessionSqlDataStructure.sessionsTable());

    databaseInstance.close();

    return allSessions;
  }
  
  Future<QuerySnapshot> retrieveSessionsSync(User firebaseUser) async {

    final querySnapshot = FirebaseFirestore.instance.collection(_databaseEndpoints.sessionsCollection(firebaseUser))
      .get(GetOptions(source: Source.server));

    return querySnapshot;
  }

  Future<List<DialogueSqlDataStructure>> retrieveDialogues(User firebaseUser, String sessionId) async {

    List<DialogueSqlDataStructure> dialogues = [];

    final databaseInstance = await _setupDatabase.initializeDatabase();

    var sessionSqlDataStructure = await _databaseUtils.rowExists(databaseInstance, sessionId);

    if (sessionSqlDataStructure != null) {

      dialogues.addAll(await _dialoguesJSON.retrieveDialogues(sessionSqlDataStructure.getSessionJsonContent()));

    }

    databaseInstance.close();

    return dialogues;
  }

  Future<List<SessionSqlDataStructure>> searchSessions(String searchQuery) async {

    final List<SessionSqlDataStructure> searchResults = [];

    if (searchQuery.length >= 3) {

      final databaseInstance = await _setupDatabase.initializeDatabase();

      final List<Map<String, dynamic>> allSessions = await databaseInstance.query(SessionSqlDataStructure.sessionsTable());

      databaseInstance.close();

      for (final element in allSessions) {

        SessionSqlDataStructure sessionSqlDataStructure = SessionSqlDataStructure.fromMap(element);

        if (sessionSqlDataStructure.getSessionTitle().contains(searchQuery)
            || sessionSqlDataStructure.getSessionSummary().contains(searchQuery)) {

          searchResults.add(sessionSqlDataStructure);

        }

      }

    }

    return searchResults;
  }

  Future<List<DocumentSnapshot>> retrieveDialoguesSync(User firebaseUser, String sessionId) async {

    List<DocumentSnapshot> dialogues = [];

    final querySnapshot = await FirebaseFirestore.instance.collection(_databaseEndpoints.sessionContentCollection(firebaseUser, sessionId))
      .orderBy(DialogueDataStructure.timestampKey, descending: false)
      .get();

    if (querySnapshot.docs.isNotEmpty) {

      for (final element in querySnapshot.docs) {

        dialogues.add(element);

      }

    }

    return dialogues;
  }

  Future retrieveSessionImages(User firebaseUser, String sessionId) async {

    final firebaseStorage = FirebaseStorage.instance.ref().child(_databaseEndpoints.sessionImages(firebaseUser, sessionId));
    firebaseStorage.list().then((elements) async {

      for (final imageElement in elements.items) {

        final imageBytes = await imageElement.getData();

        if (imageBytes != null) {

          createImageInternal(imageBytes);

        }

      }

    });

  }

  void cacheDialogues(User firebaseUser, String sessionId) async {

    FirebaseFirestore.instance.collection(_databaseEndpoints.sessionContentCollection(firebaseUser, sessionId))
        .orderBy(DialogueDataStructure.timestampKey, descending: false)
        .get(const GetOptions(source: Source.server));

  }

}