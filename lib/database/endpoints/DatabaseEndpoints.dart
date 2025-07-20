import 'package:firebase_auth/firebase_auth.dart';

class DatabaseEndpoints {

  String discussionsCollection(User firebaseUser,) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions";
  }

  String discussionContentCollection(User firebaseUser, String discussionId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions/$discussionId/Content";
  }

  /// Metadata of Discussion - Result, Summary, Timestamp
  String discussionInformationDocument(User firebaseUser, String discussionId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions/$discussionId";
  }

  String discussionItemDocument(User firebaseUser, String discussionId, String itemId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions/$discussionId/Content/$itemId";
  }

}