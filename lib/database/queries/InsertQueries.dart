
import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/discussions/data/DialogueDataStructure.dart';
import 'package:Eresse/discussions/data/DiscussionDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InsertQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  Future<DocumentReference> insertDialogues(User firebaseUser, String discussionId, ContentType contentType, String content) async {

      final documentReference = await FirebaseFirestore.instance.collection(_databaseEndpoints.discussionContentCollection(firebaseUser, discussionId))
          .add(dialogueDataStructure(contentType, content));

      return documentReference;
  }

  Future<dynamic> insertDiscussionMetadata(User firebaseUser, String discussionId) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.discussionMetadataDocument(firebaseUser, discussionId))
        .set(discussionMetadata(
          discussionId,
          '',
          '',
          DiscussionStatus.discussionOpen
    ));

    return resultCallback;
  }

}