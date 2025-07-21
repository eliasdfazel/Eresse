import 'package:cloud_firestore/cloud_firestore.dart';

dynamic generate(String discussionId, String discussionSummary) {

  return {
    DiscussionDataStructure.createdTimestampKey: Timestamp.now(),
    DiscussionDataStructure.discussionIdKey: discussionId,
    DiscussionDataStructure.discussionSummaryKey: discussionSummary,

  };
}

class DiscussionDataStructure {

  static const String createdTimestampKey = "createdTimestamp";

  static const String discussionIdKey = "discussionId";
  static const String discussionSummaryKey = "discussionSummary";

  DocumentSnapshot? _documentSnapshot;

  Map<String, dynamic> _queryDocumentData = <String, dynamic>{};

  DiscussionDataStructure(DocumentSnapshot documentSnapshot) {

    _documentSnapshot = documentSnapshot;

    _queryDocumentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String documentId() {

    return _documentSnapshot!.id;
  }

  String discussionId() {

    return _queryDocumentData[DiscussionDataStructure.discussionIdKey];
  }

  String discussionSummary() {

    return _queryDocumentData[DiscussionDataStructure.discussionSummaryKey];
  }

  String createdTimestamp() {

    return _queryDocumentData[DiscussionDataStructure.createdTimestampKey];
  }

}