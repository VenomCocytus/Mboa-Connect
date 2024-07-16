import 'package:rethink_db_ns/rethink_db_ns.dart';

// A test to verify the database creation
Future<void> createDB(RethinkDb rethinkDb, Connection connection) async {
  await rethinkDb.dbCreate('test').run(connection).catchError((error) => {});
  await rethinkDb.tableCreate('users').run(connection).catchError((error) => {});
  await rethinkDb.tableCreate('messages').run(connection).catchError((error) => {});
  await rethinkDb.tableCreate('receipts').run(connection).catchError((error) => {});
  await rethinkDb.tableCreate('typing_events').run(connection).catchError((error) => {});
}

// A test to verify the database cleaning
Future<void> cleanDB(RethinkDb rethinkDb, Connection connection) async {
  await rethinkDb.table('users').delete().run(connection);
  await rethinkDb.table('messages').delete().run(connection);
  await rethinkDb.table('receipts').delete().run(connection);
  await rethinkDb.table('typing_events').delete().run(connection);
}