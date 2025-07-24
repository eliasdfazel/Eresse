import 'package:Eresse/arwen/ask/AskQuery.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardDI {

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  Networking networking = Networking();

  RetrieveQueries retrieveQueries = RetrieveQueries();

  AskQuery askQuery = AskQuery();

}