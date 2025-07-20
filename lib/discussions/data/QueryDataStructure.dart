import 'package:cloud_firestore/cloud_firestore.dart';

class QueryDataStructure {

  static const String contentKey = "content";

  DocumentSnapshot? _documentSnapshot;
  Map<String, dynamic> _queryDocumentData = <String, dynamic>{};

  QueryDataStructure(DocumentSnapshot documentSnapshot) {

    _documentSnapshot = documentSnapshot;

    _queryDocumentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String? documentId() {

    return _documentSnapshot?.id;
  }

  String content() {

    return _queryDocumentData[QueryDataStructure.contentKey];
  }

}