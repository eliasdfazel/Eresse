import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/queries/InsertQueries.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';

abstract class Syncing {
  void databaseUpdated();
}

class SyncManager {
  
  final RetrieveQueries _retrieveQueries = RetrieveQueries();

  final InsertQueries _insertQueries = InsertQueries();

  final SetupDatabase _setupDatabase = SetupDatabase();

  Future sync(Syncing syncing) async {

    /* at the first check emptiness
  * if local empty then check backup
  *
  * if local not empty check timestamp of each sessions
  * update sessions accordingly */


    // if local database updated
    // syncing.databaseUpdated();

  }

}