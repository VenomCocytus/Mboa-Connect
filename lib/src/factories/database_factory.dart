import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseFactory {

  Future<Database> createDatabase() async {
    String databasesPath =  await getDatabasesPath();
    String mboaConnectPath = join(databasesPath, 'mboaConnect.db');

    var mboaConnectDatabase = await openDatabase(
        mboaConnectPath,
        version: 1,
        onCreate: populateDatabase
    );

    return mboaConnectDatabase;
  }

  void populateDatabase(Database database, int version) async {

    await _createChatTable(database);
    await _createMessagesTable(database);
  }

  _createChatTable(Database database) async {

    await database
        .execute(
          """CREATE TABLE chats(
                id TEXT PRIMARY KEY,
                name TEXT,
                type TEXT,
                members TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, 
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
                )""",
        )
        .then((_) => print('creating the chats table ....... ongoing'))
        .catchError((error) => ('Error creating the chats table: $error'));
  }

  _createMessagesTable(Database database) async {
    await database
        .execute("""
            CREATE TABLE messages(
              chat_id TEXT NOT NULL,
              id TEXT PRIMARY KEY,
              sender TEXT NOT NULL,
              receiver TEXT NOT NULL,
              contents TEXT NOT NULL,
              receipt TEXT NOT NULL,
              received_at TIMESTAMP NOT NULL,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
              )
        """
        ).then((_) => print('Creating the messages table ....... ongoing'))
        .catchError((error) => print('Error creating the messages table'));
  }
}