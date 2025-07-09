import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthenticationInterface {
  void authenticated(UserCredential userCredential) {
    debugPrint("Authentication: Authenticated");
  }
  void profiled(DocumentSnapshot documentSnapshot) {
    debugPrint("Authentication: Profiled");
  }
}