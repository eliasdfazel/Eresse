import 'package:cloud_firestore/cloud_firestore.dart';

enum ContentType {
  queryType, decisionType, askType
}

dynamic dialogueDataStructure(ContentType contentType, String dialogueId, {String? content, String? contentUrl}) {

  return {
    DialogueDataStructure.dialogueIdKey: dialogueId,
    DialogueDataStructure.timestampKey: dialogueId,
    DialogueDataStructure.contentTypeKey: contentType.name,
    DialogueDataStructure.contentKey: content,
  };
}

class DialogueDataStructure {

  static const String dialogueIdKey = "dialogueId";

  static const String timestampKey = "timestamp";

  static const String contentTypeKey = "contentType";
  static const String contentKey = "content";

  DocumentSnapshot? _documentSnapshot;

  Map<String, dynamic> _queryDocumentData = <String, dynamic>{};

  DialogueDataStructure(DocumentSnapshot documentSnapshot) {

    _documentSnapshot = documentSnapshot;

    _queryDocumentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String? documentId() {

    return _queryDocumentData[DialogueDataStructure.dialogueIdKey];
  }

  ContentType contentType() {

    final typeOfContent = _queryDocumentData[DialogueDataStructure.contentTypeKey];

    ContentType contentType = ContentType.queryType;

    switch (typeOfContent) {
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

  String content() {

    return _queryDocumentData[DialogueDataStructure.contentKey];
  }

  String timestamp() {

    return _queryDocumentData[DialogueDataStructure.timestampKey];
  }

}