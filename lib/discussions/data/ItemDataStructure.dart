import 'package:cloud_firestore/cloud_firestore.dart';

enum ContentType {
  queryType, decisionType, askType
}

dynamic generate(ContentType contentType, String content) {

  return {
    ItemDataStructure.timestampKey: Timestamp.now(),
    ItemDataStructure.contentTypeKey: contentType.name,
    ItemDataStructure.contentKey: content,

  };
}

class ItemDataStructure {

  static const String timestampKey = "timestamp";

  static const String contentTypeKey = "contentType";
  static const String contentKey = "content";

  DocumentSnapshot? _documentSnapshot;

  Map<String, dynamic> _queryDocumentData = <String, dynamic>{};

  ItemDataStructure(DocumentSnapshot documentSnapshot) {

    _documentSnapshot = documentSnapshot;

    _queryDocumentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String? documentId() {

    return _documentSnapshot?.id;
  }

  ContentType contentType() {

    final typeOfContent = _queryDocumentData[ItemDataStructure.contentTypeKey];

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

    return _queryDocumentData[ItemDataStructure.contentKey];
  }

  String timestamp() {

    return _queryDocumentData[ItemDataStructure.timestampKey];
  }

}