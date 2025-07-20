import 'package:firebase_auth/firebase_auth.dart';

class Databaseendpoints {

  String discussionCollection(User firebaseUser,) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions";
  }

  String discussionContentCollection(User firebaseUser, String discussionId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions/$discussionId/Content";
  }

  String discussionInformationDocument(User firebaseUser, String discussionId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions/$discussionId";
  }

  String discussionItemDocument(User firebaseUser, String discussionId, String itemId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Discussions/$discussionId/Content/$itemId";
  }

}