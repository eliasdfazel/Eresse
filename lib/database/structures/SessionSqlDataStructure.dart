import 'dart:ui';

import 'package:Eresse/database/structures/SessionDataStructure.dart';
import 'package:Eresse/resources/colors_resources.dart';

class SessionSqlDataStructure {

  static const String databaseTableName = "sessions";

  /// sessions.db
  static String sessionsDatabase() {

    return "sessions.db";
  }

  /// For Multi-User Support Append UserID to Table Name
  static String sessionsTable() {

    return "sessions";
  }

  String sessionId;

  String createdTimestamp;
  String updatedTimestamp;

  String sessionTitle;
  String sessionSummary;

  String sessionStatus;

  String sessionJsonContent;

  SessionSqlDataStructure({
    required this.sessionId,

    required this.createdTimestamp,
    required this.updatedTimestamp,

    required this.sessionTitle,
    required this.sessionSummary,

    required this.sessionStatus,

    required this.sessionJsonContent
  });

  Map<String, dynamic> toMap() {

    return {
      SessionDataStructure.sessionIdKey: sessionId,

      SessionDataStructure.createdTimestampKey: createdTimestamp,
      SessionDataStructure.updatedTimestampKey: updatedTimestamp,

      SessionDataStructure.sessionTitleKey: sessionTitle,
      SessionDataStructure.sessionSummaryKey: sessionSummary,

      SessionDataStructure.sessionStatusKey: sessionStatus,

      SessionDataStructure.sessionJsonContentKey: sessionJsonContent
    };
  }

  static SessionSqlDataStructure fromMap(Map<String, Object?> inputMap) {

    return SessionSqlDataStructure(
        sessionId: inputMap[SessionDataStructure.sessionIdKey].toString(),
        createdTimestamp: inputMap[SessionDataStructure.createdTimestampKey].toString(),
        updatedTimestamp: inputMap[SessionDataStructure.updatedTimestampKey].toString(),
        sessionTitle: inputMap[SessionDataStructure.sessionTitleKey].toString(),
        sessionSummary: inputMap[SessionDataStructure.sessionSummaryKey].toString(),
        sessionStatus: inputMap[SessionDataStructure.sessionStatusKey].toString(),
        sessionJsonContent: inputMap[SessionDataStructure.sessionJsonContentKey].toString()
    );
  }

  static SessionSqlDataStructure fromMapSync(Map<String, Object?> inputMap, String sessionJsonContentKey) {

    return SessionSqlDataStructure(
        sessionId: inputMap[SessionDataStructure.sessionIdKey].toString(),
        createdTimestamp: inputMap[SessionDataStructure.createdTimestampKey].toString(),
        updatedTimestamp: inputMap[SessionDataStructure.updatedTimestampKey].toString(),
        sessionTitle: inputMap[SessionDataStructure.sessionTitleKey].toString(),
        sessionSummary: inputMap[SessionDataStructure.sessionSummaryKey].toString(),
        sessionStatus: inputMap[SessionDataStructure.sessionStatusKey].toString(),
        sessionJsonContent: sessionJsonContentKey
    );
  }

  String getSessionId() {

    return sessionId;
  }

  String getSessionTitle() {

    return sessionTitle;
  }

  void setSessionTitle(String sessionTitle) {

    this.sessionTitle = sessionTitle;

  }

  String getSessionSummary() {

    return sessionSummary;
  }

  void setSessionSummary(String sessionSummary) {

    this.sessionSummary = sessionSummary;

  }

  void setSessionJsonContent(String sessionJsonContent) {

    this.sessionJsonContent = sessionJsonContent;

  }

  String getSessionJsonContent() {

    return (sessionJsonContent.isEmpty) ? '[]' : sessionJsonContent;
  }

  void setUpdatedTimestamp(String updatedTimestamp) {

    this.updatedTimestamp = updatedTimestamp;

  }

  String getSessionStatus() {

    return sessionStatus;
  }

  void setSessionStatus(String sessionStatus) {

    this.sessionStatus = sessionStatus;

  }

  SessionStatus sessionStatusIndicator() {

    SessionStatus statusType = SessionStatus.sessionOpen;

    switch (getSessionStatus()) {
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

  Color statusIndicatorColor() {

    switch (sessionStatusIndicator()) {
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

  void setUpdateTimestamp(String updatedTimestamp) {

    this.updatedTimestamp = updatedTimestamp;

  }

  int getUpdateTimestamp() {

    return int.parse(updatedTimestamp);
  }

}