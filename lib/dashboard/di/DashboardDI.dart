import 'package:Eresse/arwen/ask/AskQuery.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/queries/DatabaseUtils.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:Eresse/database/sync/SyncManager.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardDI {

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  Networking networking = Networking();

  RetrieveQueries retrieveQueries = RetrieveQueries();

  final DialoguesJSON dialoguesJSON = DialoguesJSON();

  AskQuery askQuery = AskQuery();

  SyncManager syncManager = SyncManager();

  DatabaseUtils databaseUtils = DatabaseUtils();

}