import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/queries/InsertQueries.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Syncing {
  void databaseUpdated();
}

class SyncManager {
  
  final RetrieveQueries _retrieveQueries = RetrieveQueries();

  final InsertQueries _insertQueries = InsertQueries();

  final SetupDatabase _setupDatabase = SetupDatabase();

  Future sync(Syncing syncing, User firebaseUser) async {

    final localSessions = await _retrieveQueries.retrieveSessions(firebaseUser);

    if (localSessions.isEmpty) {

      final cloudSessions = await _retrieveQueries.retrieveSessionsSync(firebaseUser);

      if (cloudSessions.docs.isNotEmpty) {

        // insert from cloud to local database
        for (final element in cloudSessions.docs) {

          _insertQueries.insertSession();

        }

      }

    } else {



    }
    /* at the first check emptiness
      * if local empty then check backup
      *
      * if local not empty check timestamp of each sessions
      * update sessions accordingly */


    // if local database updated
    // syncing.databaseUpdated();

  }

}