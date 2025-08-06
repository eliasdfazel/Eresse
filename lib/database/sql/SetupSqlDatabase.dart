import 'package:Eresse/database/structures/SessionSqlDataStructure.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SetupDatabase {

  Future<Database> initializeDatabase() async {

    Database databaseInstance = await openDatabase(join(await getDatabasesPath(), SessionSqlDataStructure.sessionsDatabase()), version: 13,
        onCreate: (Database database, int version) async {
          await database.execute(
              '''
              CREATE TABLE IF NOT EXISTS ${SessionSqlDataStructure.sessionsTable()} ( 
                sessionId TEXT PRIMARY KEY, 
                createdTimestamp TEXT NOT NULL,
                updatedTimestamp TEXT NOT NULL,
                sessionTitle TEXT NOT NULL,
                sessionSummary TEXT NOT NULL,
                sessionStatus TEXT NOT NULL,
                sessionJsonContent TEXT NOT NULL
              )
            '''
          );
        });

    return databaseInstance;
  }

  Future closeDatabase(Database databaseInstance) async {

    if (databaseInstance.isOpen) {

      await databaseInstance.close();

    }

  }

}