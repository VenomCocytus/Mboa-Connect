import 'package:chat/src/models/messages/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_service_impl.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import '../helper.dart';

void main() {
  RethinkDb rethinkDb = RethinkDb();
  Connection? connection;
  late MessageService messageService;

  setUp(() async {
    connection =  await rethinkDb.connect(host: '127.0.0.1', port: 28015);
    final encryption = EncryptionService(Encrypter(AES(Key.fromLength(32))));

    await createDB(rethinkDb, connection!);
    messageService = MessageService(rethinkDb, connection!, encryption: encryption);
  });

  tearDown(() async {
    messageService.dispose();
    await cleanDB(rethinkDb, connection!);
  });

  final user = User.fromMap({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  final user2 = User.fromMap({
    'id': '1111',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  test("Sending messages successfully", () async {
    Message message = Message(
      groupId: '123',
      source: user.id,
      destination: '3456',
      timestamp: DateTime.now(),
      contents: 'This is a message',
    );
    final result = await messageService.sendMessages([message]);

    // Testing
    expect(result.id, isNotEmpty);
  });

  test("Successfully login and receive messages", () async {
    const contents = 'this is a message';

    messageService.getAllMessages(activeUser: user2)
        .listen(expectAsync1((message) {
          expect(message.destination, user2.id);
          expect(message.id, isNotEmpty);
          expect(message.contents, contents);
        }, count: 2));

    Message message = Message(
      groupId: '123',
      source: user.id,
      destination: user2.id,
      timestamp: DateTime.now(),
      contents: contents,
    );

    Message secondMessage = Message(
      groupId: '123',
      source: user.id,
      destination: user2.id,
      timestamp: DateTime.now(),
      contents: contents,
    );

    await messageService.sendMessages([message]);
    await messageService.sendMessages([secondMessage]);
  });

  test("Successfully login and receive new messages", () async {
    Message message = Message(
      groupId: '1232',
      source: user.id,
      destination: user2.id,
      timestamp: DateTime.now(),
      contents: 'this is a message',
    );

    Message secondMessage = Message(
      groupId: '123',
      source: user.id,
      destination: user2.id,
      timestamp: DateTime.now(),
      contents: 'this is another message',
    );

    await messageService.sendMessages([message]);
    await messageService.sendMessages([secondMessage]).whenComplete(
            () => messageService.getAllMessages(activeUser: user2)
                .listen(expectAsync1((message) {
                  expect(message.destination, user2.id);
              }, count: 2),
            ),
    );
  });

}