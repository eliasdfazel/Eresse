import 'package:firebase_auth/firebase_auth.dart';

class DatabaseEndpoints {

  String sessionsCollection(User firebaseUser,) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Sessions";
  }

  String sessionContentCollection(User firebaseUser, String sessionId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Sessions/$sessionId/Content";
  }

  /// Metadata of Session - Result, Summary, Timestamp
  String sessionMetadataDocument(User firebaseUser, String sessionId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Sessions/$sessionId";
  }

  String sessionElementDocument(User firebaseUser, String sessionId, String elementId) {

    return "Eresse/${firebaseUser.email!.toUpperCase()}/Sessions/$sessionId/Content/$elementId";
  }

  String sessionImages(User firebaseUser, String sessionId) {

    return 'Eresse/${firebaseUser.email!.toUpperCase()}/Sessions/$sessionId/Content';
  }

  String sessionElementImage(User firebaseUser, String sessionId, String elementId) {

    return 'Eresse/${firebaseUser.email!.toUpperCase()}/Sessions/$sessionId/Content/$elementId';
  }

}