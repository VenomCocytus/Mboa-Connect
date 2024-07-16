import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import '../helper.dart';

void main() {
  RethinkDb rethinkDb = RethinkDb();
  Connection? connection;
  late UserService userService;

  setUp(() async {
    connection = await rethinkDb.connect(host: '127.0.0.1', port: 28015);
    await createDB(rethinkDb, connection!);
    userService = UserService(rethinkDb, connection!);
  });

  tearDown(() async {
    await cleanDB(rethinkDb, connection!);
  });

  test('Create a new user document in the database', () async {
    // User creation
    final user = User(
      firstName: 'Allan',
      lastName: 'Wake',
      photoUrl: 'url',
      active: true,
      lastSeen: DateTime.now()
    );

    final userWithIdAndUsername = await userService.login(user);

    // Testing
    expect(userWithIdAndUsername.id, isNotEmpty);
    expect(userWithIdAndUsername.username,
        "${userWithIdAndUsername.firstName}_${userWithIdAndUsername.lastName}".toLowerCase());
  });

  test('Get Online Users', () async {
    final user = User(
        firstName: 'Allan',
        lastName: 'Wake',
        photoUrl: 'url',
        active: true,
        lastSeen: DateTime.now()
    );

    // Setting up private fields
    await userService.login(user);

    // Action
    final users = await userService.getOnlineUsers();

    // Testing
    expect(users.length, 1);
  });
}