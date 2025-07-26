import 'dart:ui';

import 'package:Eresse/resources/colors_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum DiscussionStatus {
  discussionOpen, discussionSuccess, discussionFailed,
}

dynamic discussionMetadata(String discussionId, DiscussionStatus discussionStatus) {

  return {
    DiscussionDataStructure.createdTimestampKey: Timestamp.now(),
    DiscussionDataStructure.updatedTimestampKey: Timestamp.now(),
    DiscussionDataStructure.discussionIdKey: discussionId,

    DiscussionDataStructure.discussionStatusKey: discussionStatus.name,
  };
}

dynamic discussionUpdateMetadata() {

  return {
    DiscussionDataStructure.updatedTimestampKey: Timestamp.now(),
  };
}

dynamic discussionUpdateContext({String discussionTitle = 'N/A', String discussionSummary = 'N/A'}) {

  return {
    DiscussionDataStructure.discussionTitleKey: discussionTitle,
    DiscussionDataStructure.discussionSummaryKey: discussionSummary,
  };
}

class DiscussionDataStructure {

  static const String createdTimestampKey = "createdTimestamp";
  static const String updatedTimestampKey = "updatedTimestamp";

  static const String discussionIdKey = "discussionId";
  static const String discussionTitleKey = "discussionTitle";
  static const String discussionSummaryKey = "discussionSummary";

  static const String discussionStatusKey = "discussionStatus";

  static const int contextThreshold = 7;

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

  DiscussionStatus discussionStatus() {

    final typeOfStatus = _queryDocumentData[DiscussionDataStructure.discussionStatusKey];

    DiscussionStatus statusType = DiscussionStatus.discussionOpen;

    switch (typeOfStatus) {
      case "discussionOpen": {

        statusType = DiscussionStatus.discussionOpen;

        break;
      }
      case "discussionSuccess": {

        statusType = DiscussionStatus.discussionSuccess;

        break;
      }
      case "discussionFailed": {

        statusType = DiscussionStatus.discussionFailed;

        break;
      }
    }

    return statusType;
  }

  Color statusIndicator() {

    switch (discussionStatus()) {
      case DiscussionStatus.discussionOpen: {

        return ColorsResources.openColor;
      }
      case DiscussionStatus.discussionSuccess: {

        return ColorsResources.successColor;
      }
      case DiscussionStatus.discussionFailed: {

        return ColorsResources.failedColor;
      }
    }
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