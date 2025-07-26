import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DiscussionDataStructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RetrieveQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  Future<QuerySnapshot> retrieveDiscussions(User firebaseUser) async {

    final querySnapshot = FirebaseFirestore.instance.collection(_databaseEndpoints.discussionsCollection(firebaseUser))
      .limit(7)
      .where(DiscussionDataStructure.discussionStatusKey, isEqualTo: DiscussionStatus.discussionOpen.name)
      .get(GetOptions(source: Source.server));

    return querySnapshot;
  }

  Future<List<DocumentSnapshot>> retrieveDialogues(User firebaseUser, String discussionId) async {

    List<DocumentSnapshot> dialogues = [];

    final querySnapshot = await FirebaseFirestore.instance.collection(_databaseEndpoints.discussionContentCollection(firebaseUser, discussionId))
      .orderBy(DialogueDataStructure.timestampKey, descending: false)
      .get();

    if (querySnapshot.docs.isNotEmpty) {

      for (final element in querySnapshot.docs) {

        dialogues.add(element);

      }

    }

    return dialogues;
  }

  void cacheDialogues(User firebaseUser, String discussionId) async {

    FirebaseFirestore.instance.collection(_databaseEndpoints.discussionContentCollection(firebaseUser, discussionId))
        .orderBy(DialogueDataStructure.timestampKey, descending: false)
        .get(const GetOptions(source: Source.server));

  }

}