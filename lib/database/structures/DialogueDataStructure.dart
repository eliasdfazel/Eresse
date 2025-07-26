import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ContentType {
  queryType, decisionType, askType
}

dynamic dialogueDataStructure(ContentType contentType, String content) {

  return {
    DialogueDataStructure.timestampKey: now(),
    DialogueDataStructure.contentTypeKey: contentType.name,
    DialogueDataStructure.contentKey: content,

  };
}

class DialogueDataStructure {

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

    return _documentSnapshot?.id;
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