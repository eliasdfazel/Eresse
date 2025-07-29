import 'dart:ui';

import 'package:Eresse/resources/colors_resources.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SessionStatus {
  sessionOpen, sessionSuccess, sessionFailed,
}

dynamic sessionMetadata(String sessionId, SessionStatus sessionStatus) {

  return {
    SessionDataStructure.createdTimestampKey: now(),
    SessionDataStructure.updatedTimestampKey: now(),
    SessionDataStructure.sessionIdKey: sessionId,
    SessionDataStructure.sessionTitleKey: 'N/A',
    SessionDataStructure.sessionSummaryKey: 'N/A',
    SessionDataStructure.sessionStatusKey: sessionStatus.name,
  };
}

dynamic sessionUpdateMetadata() {

  return {
    SessionDataStructure.updatedTimestampKey: now(),
  };
}

dynamic sessionUpdateContext({String sessionTitle = 'N/A', String sessionSummary = 'N/A'}) {

  return {
    SessionDataStructure.sessionTitleKey: sessionTitle,
    SessionDataStructure.sessionSummaryKey: sessionSummary,
  };
}

class SessionDataStructure {

  static const String createdTimestampKey = "createdTimestamp";
  static const String updatedTimestampKey = "updatedTimestamp";

  static const String sessionIdKey = "sessionId";
  static const String sessionTitleKey = "sessionTitle";
  static const String sessionSummaryKey = "sessionSummary";

  static const String sessionStatusKey = "sessionStatus";

  static const String sessionJsonContentKey = "sessionJsonContent";

  static const int contextThreshold = 7;

  DocumentSnapshot? _documentSnapshot;

  Map<String, dynamic> _queryDocumentData = <String, dynamic>{};

  SessionDataStructure(DocumentSnapshot documentSnapshot) {

    _documentSnapshot = documentSnapshot;

    _queryDocumentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String documentId() {

    return _documentSnapshot!.id;
  }

  String sessionId() {

    return _queryDocumentData[SessionDataStructure.sessionIdKey];
  }

  SessionStatus sessionStatus() {

    final typeOfStatus = _queryDocumentData[SessionDataStructure.sessionStatusKey];

    SessionStatus statusType = SessionStatus.sessionOpen;

    switch (typeOfStatus) {
      case "sessionOpen": {

        statusType = SessionStatus.sessionOpen;

        break;
      }
      case "sessionSuccess": {

        statusType = SessionStatus.sessionSuccess;

        break;
      }
      case "sessionFailed": {

        statusType = SessionStatus.sessionFailed;

        break;
      }
    }

    return statusType;
  }

  Color statusIndicator() {

    switch (sessionStatus()) {
      case SessionStatus.sessionOpen: {

        return ColorsResources.openColor;
      }
      case SessionStatus.sessionSuccess: {

        return ColorsResources.successColor;
      }
      case SessionStatus.sessionFailed: {

        return ColorsResources.failedColor;
      }
    }
  }

  String sessionSummary() {

    return _queryDocumentData[SessionDataStructure.sessionSummaryKey];
  }

  String sessionTitle() {

    return _queryDocumentData[SessionDataStructure.sessionTitleKey];
  }

  String createdTimestamp() {

    return _queryDocumentData[SessionDataStructure.createdTimestampKey];
  }

  int updatedTimestamp() {

    return int.parse(_queryDocumentData[SessionDataStructure.updatedTimestampKey].toString());
  }

}