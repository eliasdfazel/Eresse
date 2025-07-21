import 'package:cloud_firestore/cloud_firestore.dart';

enum DiscussionStatus {
  discussionOpen, discussionSuccess, discussionFailed,
}

dynamic generate(String discussionId, String discussionTitle, String discussionSummary) {

  return {
    DiscussionDataStructure.createdTimestampKey: Timestamp.now(),
    DiscussionDataStructure.discussionIdKey: discussionId,
    DiscussionDataStructure.discussionTitleKey: discussionTitle,
    DiscussionDataStructure.discussionSummaryKey: discussionSummary,
  };
}

class DiscussionDataStructure {

  static const String createdTimestampKey = "createdTimestamp";

  static const String discussionIdKey = "discussionId";
  static const String discussionTitleKey = "discussionTitle";
  static const String discussionSummaryKey = "discussionSummary";

  static const String discussionStatusKey = "discussionStatus";

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

  String discussionTitle() {

    return _queryDocumentData[DiscussionDataStructure.discussionTitleKey];
  }

  String createdTimestamp() {

    return _queryDocumentData[DiscussionDataStructure.createdTimestampKey];
  }

}