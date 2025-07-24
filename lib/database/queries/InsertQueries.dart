
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/discussions/data/DialogueDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InsertQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  Future insertDialogues(User firebaseUser, String discussionId, ContentType contentType, String content) async {

      final documentReference = await FirebaseFirestore.instance.collection(_databaseEndpoints.discussionContentCollection(firebaseUser, discussionId))
          .add(generate(contentType, content));

      return documentReference;
  }

}