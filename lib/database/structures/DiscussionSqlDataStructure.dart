class DiscussionSqlDataStructure {

  static const String databaseTableName = "discussions";

  /// discussions.db
  static String discussionDatabase() {

    return "discussions.db";
  }

  /// For Multi-User Support Append UserID to Table Name
  static String discussionsTable() {

    return "discussions";
  }

  String discussionId;

  String createdTimestamp;
  String updatedTimestamp;

  String discussionTitle;
  String discussionSummary;

  String discussionStatus;

  String discussionJsonContent;

  DiscussionSqlDataStructure({
    required this.discussionId,

    required this.createdTimestamp,
    required this.updatedTimestamp,

    required this.discussionTitle,
    required this.discussionSummary,

    required this.discussionStatus,

    required this.discussionJsonContent
  });

  Map<String, dynamic> toMap() {
    return {
      'discussionId': discussionId,

      'createdTimestamp': createdTimestamp,
      'updatedTimestamp': updatedTimestamp,

      'discussionTitle': discussionTitle,
      'discussionSummary': discussionSummary,

      'discussionStatus': discussionStatus,

      'discussionJsonContent': discussionJsonContent
    };
  }

  static DiscussionSqlDataStructure fromMap(Map<String, Object?> inputMap) {

    return DiscussionSqlDataStructure(
        discussionId: inputMap['discussionId'].toString(),
        createdTimestamp: inputMap['createdTimestamp'].toString(),
        updatedTimestamp: inputMap['updatedTimestamp'].toString(),
        discussionTitle: inputMap['discussionTitle'].toString(),
        discussionSummary: inputMap['discussionSummary'].toString(),
        discussionStatus: inputMap['discussionStatus'].toString(),
        discussionJsonContent: inputMap['discussionJsonContent'].toString()
    );
  }

  void setDiscussionJsonContent(String discussionJsonContent) {

    this.discussionJsonContent = discussionJsonContent;

  }

  void setUpdatedTimestamp(String updatedTimestamp) {

    this.updatedTimestamp = updatedTimestamp;

  }

}