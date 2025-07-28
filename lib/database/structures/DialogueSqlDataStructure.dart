import 'DialogueDataStructure.dart' show DialogueDataStructure, ContentType;

class DialogueSqlDataStructure {

  String dialogueId;

  String timestamp;

  String contentType;
  String content;

  DialogueSqlDataStructure({
    required this.dialogueId,

    required this.timestamp,

    required this.contentType,
    required this.content
  });

  Map<String, dynamic> toMap() {
    return {
      DialogueDataStructure.dialogueIdKey: dialogueId,

      DialogueDataStructure.timestampKey: timestamp,

      DialogueDataStructure.contentTypeKey: contentType,
      DialogueDataStructure.contentKey: content
    };
  }

  static DialogueSqlDataStructure fromMap(Map<String, Object?> inputMap) {

    return DialogueSqlDataStructure(
      dialogueId: inputMap[DialogueDataStructure.dialogueIdKey].toString(),
      timestamp: inputMap[DialogueDataStructure.timestampKey].toString(),
      contentType: inputMap[DialogueDataStructure.contentTypeKey].toString(),
      content: inputMap[DialogueDataStructure.contentKey].toString(),
    );
  }

  String getDialogueId() {

    return dialogueId;
  }

  String getContent() {

    return content;
  }

  String getContentType() {

    return contentType;
  }

  ContentType contentTypeIndicator() {


    ContentType contentType = ContentType.queryType;

    switch (getContentType()) {
      case "queryType": {

        contentType = ContentType.queryType;

        break;
      }
      case "decisionType": {

        contentType = ContentType.decisionType;

        break;
      }
      case "askType": {

        contentType = ContentType.askType;

        break;
      }
    }

    return contentType;
  }

  String getTimestamp() {

    return timestamp;
  }

}