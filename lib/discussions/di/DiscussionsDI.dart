import 'package:Eresse/database/endpoints/DatabaseEndpoints.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscussionsDI {

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  DatabaseEndpoints databaseEndpoints = DatabaseEndpoints();

  Networking networking = Networking();

}