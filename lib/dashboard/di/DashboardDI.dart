import 'package:firebase_auth/firebase_auth.dart';

class DashboardDI {

  User? firebaseUser = FirebaseAuth.instance.currentUser;

}