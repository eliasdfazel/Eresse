import 'package:Eresse/database/structures/DiscussionSqlDataStructure.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SetupDatabase {

  Future<Database> initializeDatabase() async {

    Database databaseInstance = await openDatabase(join(await getDatabasesPath(), DiscussionSqlDataStructure.discussionDatabase()), version: 13,
        onCreate: (Database database, int version) async {
          await database.execute(
              '''
              CREATE TABLE IF NOT EXISTS ${DiscussionSqlDataStructure.discussionsTable()} ( 
                discussionId TEXT PRIMARY KEY, 
                createdTimestamp TEXT NOT NULL,
                updatedTimestamp TEXT NOT NULL,
                discussionTitle TEXT NOT NULL,
                discussionSummary TEXT NOT NULL,
                discussionStatus TEXT NOT NULL,
                discussionJsonContent TEXT NOT NULL
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

  Future<DiscussionSqlDataStructure?> rowExists(Database databaseInstance, String discussionId) async {

    DiscussionSqlDataStructure? discussionSqlDataStructure;

    final rowsResults = (await databaseInstance.rawQuery('SELECT * FROM ${DiscussionSqlDataStructure.discussionsTable()} WHERE discussionId = $discussionId'));

    if (rowsResults.isNotEmpty) {

      Map<String, Object?> discussionSqlDataStructureMap = rowsResults.first;

      discussionSqlDataStructure = DiscussionSqlDataStructure.fromMap(discussionSqlDataStructureMap);

    }

    return discussionSqlDataStructure;
  }

}