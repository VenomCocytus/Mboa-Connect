import 'package:chat/src/common/define/typing_states.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/notifications/typing_event.dart';
import 'package:chat/src/services/notification/typing/typing_notification_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import '../Mockito/mock_user_service.dart';
import '../helper.dart';

void main() {
  RethinkDb rethinkDb = RethinkDb();
  Connection? connection;
  late TypingNotificationService typingNotificationService;
  late MockUserService mockUserService;
  
  setUp(() async {
    connection = await rethinkDb.connect();
    await createDB(rethinkDb, connection!);
    mockUserService = MockUserService();
    typingNotificationService = TypingNotificationService(rethinkDb, connection, mockUserService);
  });

  tearDown(() async {
    typingNotificationService.dispose();
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
  
  test("sending typing notification successfully", () async {
    TypingEvent typingEvent = TypingEvent(
        chatId: "12",
        source: user2.id,
        destination: user.id,
        event: TypingStates.start);

    when(mockUserService.getAllUsers(any))
        .thenAnswer((_) async => [user]);
    final result = await typingNotificationService.sendNotification(events: [typingEvent]);

    expect(result, true);
  });

  test('successfully login and receiving typing notifications', () async {
    typingNotificationService.subscribeToNotification(user2, [user.id])
        .listen(
          expectAsync1((event) {
            expect(event.source, user.id);
          }, count: 2)
    );

    when(mockUserService.getAllUsers(any)).thenAnswer((_) async => [user2]);

    TypingEvent typing = TypingEvent(
      chatId: '123',
      destination: user2.id,
      source: user.id,
      event: TypingStates.start,
    );

    TypingEvent stopTyping = TypingEvent(
      chatId: '123',
      destination: user2.id,
      source: user.id,
      event: TypingStates.stop,
    );

    await typingNotificationService.sendNotification(events: [typing]);
    await typingNotificationService.sendNotification(events: [stopTyping]);
  });

}