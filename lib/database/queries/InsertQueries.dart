import 'dart:core';

import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/database/setup/SetupDatabase.dart';
import 'package:Eresse/database/structures/DialogueDataStructure.dart';
import 'package:Eresse/database/structures/DiscussionDataStructure.dart';
import 'package:Eresse/database/structures/DiscussionSqlDataStructure.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InsertQueries {

  final DatabaseEndpoints _databaseEndpoints = DatabaseEndpoints();

  final SetupDatabase setupDatabase = SetupDatabase();

  /// content = discussionJsonContent
  Future<DiscussionSqlDataStructure> insertDialogues(User firebaseUser, String discussionId, ContentType contentType, String content) async {

    final databaseInstance = await setupDatabase.initializeDatabase();

    var discussionSqlDataStructure = await setupDatabase.rowExists(databaseInstance, discussionId);

    if (discussionSqlDataStructure != null) {

      discussionSqlDataStructure.setDiscussionJsonContent(content);
      discussionSqlDataStructure.setUpdatedTimestamp(now().toString());

      databaseInstance.update(DiscussionSqlDataStructure.discussionsTable(), discussionSqlDataStructure.toMap());

    } else {

      discussionSqlDataStructure = DiscussionSqlDataStructure(
          discussionId: discussionId,
          createdTimestamp: now().toString(),
          updatedTimestamp: now().toString(),
          discussionTitle: '',
          discussionSummary: '',
          discussionStatus: DiscussionStatus.discussionOpen.name,
          discussionJsonContent: content
      );

      databaseInstance.insert(DiscussionSqlDataStructure.discussionsTable(), discussionSqlDataStructure.toMap());

    }

    return discussionSqlDataStructure;

  }

  Future<DocumentReference> _insertDialogues(User firebaseUser, String discussionId, ContentType contentType, String content) async {

      final documentReference = await FirebaseFirestore.instance.collection(_databaseEndpoints.discussionContentCollection(firebaseUser, discussionId))
          .add(dialogueDataStructure(contentType, content));

      return documentReference;
  }

  Future<dynamic> insertDiscussionMetadata(User firebaseUser, String discussionId) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.discussionMetadataDocument(firebaseUser, discussionId))
        .set(discussionMetadata(
          discussionId,
          DiscussionStatus.discussionOpen
    ));

    return resultCallback;
  }

  Future<dynamic> updateDiscussionMetadata(User firebaseUser, String discussionId) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.discussionMetadataDocument(firebaseUser, discussionId))
        .update(discussionUpdateMetadata());

    return resultCallback;
  }

  Future<dynamic> updateDiscussionContext(User firebaseUser, String discussionId, String discussionTitle, String discussionSummary) async {

    final resultCallback = await FirebaseFirestore.instance.doc(_databaseEndpoints.discussionMetadataDocument(firebaseUser, discussionId))
        .update(discussionUpdateContext(
          discussionTitle: discussionTitle,
          discussionSummary: discussionSummary
        ));

    return resultCallback;
  }

}