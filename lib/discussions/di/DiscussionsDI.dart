import 'package:Eresse/database/queries/InsertQueries.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscussionsDI {

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  Networking networking = Networking();

  InsertQueries insertQueries = InsertQueries();

  RetrieveQueries retrieveQueries = RetrieveQueries();

}