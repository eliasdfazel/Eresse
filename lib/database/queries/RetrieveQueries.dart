import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart' show DialoguesJSON;
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RetrieveQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  final SetupDatabase _setupDatabase = SetupDatabase();

  final DialoguesJSON _dialoguesJSON = DialoguesJSON();
  
  Future<List<Map<String, dynamic>>> retrieveSessions(User firebaseUser) async {

    final databaseInstance = await _setupDatabase.initializeDatabase();

    final List<Map<String, dynamic>> allSessions = await databaseInstance.query(SessionSqlDataStructure.sessionsTable());


    print('>>> $allSessions');

    for (var element in allSessions) {

      print('>>> element; ${element}');


    }



    // databaseInstance.query(table)

    return allSessions;
  }
  
  Future<QuerySnapshot> _retrieveSessions(User firebaseUser) async {

    final querySnapshot = FirebaseFirestore.instance.collection(_databaseEndpoints.sessionsCollection(firebaseUser))
      .limit(7)
      .where(SessionDataStructure.sessionStatusKey, isEqualTo: SessionStatus.sessionOpen.name)
      .get(GetOptions(source: Source.server));

    return querySnapshot;
  }

  Future<List<DocumentSnapshot>> retrieveDialogues(User firebaseUser, String sessionId) async {

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

  void cacheDialogues(User firebaseUser, String sessionId) async {

    FirebaseFirestore.instance.collection(_databaseEndpoints.sessionContentCollection(firebaseUser, sessionId))
        .orderBy(DialogueDataStructure.timestampKey, descending: false)
        .get(const GetOptions(source: Source.server));

  }

}