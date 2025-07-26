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
                discussionId INTEGER PRIMARY KEY, 
                createdTimestamp INTEGER NOT NULL,
                updatedTimestamp INTEGER NOT NULL,
                discussionSummary TEXT NOT NULL,
                discussionStatus TEXT NOT NULL,
                discussionJsonContent TEXT NOT NULL,
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

    Map<String, Object?> discussionSqlDataStructureMap = (await databaseInstance.rawQuery('SELECT * FROM ${DiscussionSqlDataStructure.discussionsTable()} WHERE discussionId IN $discussionId')).first;

    if (discussionSqlDataStructureMap.isNotEmpty) {

      discussionSqlDataStructure = DiscussionSqlDataStructure.fromMap(discussionSqlDataStructureMap);

    }

    return discussionSqlDataStructure;
  }

}