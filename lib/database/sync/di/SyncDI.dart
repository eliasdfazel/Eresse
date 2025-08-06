import 'package:Eresse/database/SQL/SetupSqlDatabase.dart';
import 'package:Eresse/database/json/DialoguesJSON.dart';
import 'package:Eresse/database/queries/DatabaseUtils.dart';
import 'package:Eresse/database/queries/InsertQueries.dart';
import 'package:Eresse/database/queries/RetrieveQueries.dart';

class SyncDI {

  final SetupDatabase setupDatabase = SetupDatabase();

  final DatabaseUtils databaseUtils = DatabaseUtils();

  final RetrieveQueries retrieveQueries = RetrieveQueries();

  final InsertQueries insertQueries = InsertQueries();

  final DialoguesJSON dialoguesJSON = DialoguesJSON();

}