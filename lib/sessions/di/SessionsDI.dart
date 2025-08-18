import 'package:Eresse/arwen/ask/AskQuery.dart';
import 'package:Eresse/database/queries/DatabaseUtils.dart';
import 'package:Eresse/database/queries/InsertQueries.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:Eresse/utils/network/Networking.dart';
import 'package:Eresse/utils/time/TimesIO.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../database/json/DialoguesJSON.dart';

class SessionsDI {

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  Networking networking = Networking();

  InsertQueries insertQueries = InsertQueries();

  DatabaseUtils databaseUtils = DatabaseUtils();

  RetrieveQueries retrieveQueries = RetrieveQueries();

  AskQuery askQuery = AskQuery();

  DialoguesJSON dialoguesJSON = DialoguesJSON();

  TimesIO timesIO = TimesIO();

}