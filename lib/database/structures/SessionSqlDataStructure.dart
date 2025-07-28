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
      'sessionId': sessionId,

      'createdTimestamp': createdTimestamp,
      'updatedTimestamp': updatedTimestamp,

      'sessionTitle': sessionTitle,
      'sessionSummary': sessionSummary,

      'sessionStatus': sessionStatus,

      'sessionJsonContent': sessionJsonContent
    };
  }

  static SessionSqlDataStructure fromMap(Map<String, Object?> inputMap) {

    return SessionSqlDataStructure(
        sessionId: inputMap['sessionId'].toString(),
        createdTimestamp: inputMap['createdTimestamp'].toString(),
        updatedTimestamp: inputMap['updatedTimestamp'].toString(),
        sessionTitle: inputMap['sessionTitle'].toString(),
        sessionSummary: inputMap['sessionSummary'].toString(),
        sessionStatus: inputMap['sessionStatus'].toString(),
        sessionJsonContent: inputMap['sessionJsonContent'].toString()
    );
  }

  void setSessionJsonContent(String sessionJsonContent) {

    this.sessionJsonContent = sessionJsonContent;

  }

  void setUpdatedTimestamp(String updatedTimestamp) {

    this.updatedTimestamp = updatedTimestamp;

  }

}