import 'dart:async';

import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/notifications/typing_event.dart';
import 'package:chat/src/services/notification/typing/typing_notification_service_contract.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class TypingNotificationService implements ITypingNotification {
  final Connection? _connection;
  final RethinkDb _rethinkDb;

  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription? _changeFeed;
  final IUserService? _iUserService;

  TypingNotificationService(this._rethinkDb, this._connection, this._iUserService);


  @override
  void dispose() {
    _changeFeed?.cancel();
    _controller.close();
  }

  @override
  Future<bool> sendNotification({required List<TypingEvent> events}) async {
    final notifiedUsers = await _iUserService!
        .getAllUsers(events.map((event) => event.destination).toList());

    if(notifiedUsers.isEmpty) return false;

    events.retainWhere((event) => notifiedUsers.map((user) => user.id).contains(event.destination));

    final data = events.map((event) => event.toMap()).toList();

    Map record = await (_rethinkDb
        .table('typing_events')
        .insert(data, {'conflict': 'update'})
        .run(_connection!));

    return record['inserted'] >= 1;
  }

  @override
  Stream<TypingEvent> subscribeToNotification(User user, List<String?> userIds) {
    _startReceivingTypingNotifications(user, userIds);
    return _controller.stream;
  }

  _startReceivingTypingNotifications(User user, List<String?> userIds) {
    _changeFeed = _rethinkDb
        .table('typing_events')
        .filter((event) {
          return event('destination')
              .eq(user.id)
              .and(_rethinkDb
                    .expr(userIds)
                    .contains(event('source')));
        })
        .changes({'include_initial': true})
        .run(_connection!)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((typingNotificationFeeData) {
                if(typingNotificationFeeData['new_val'] == null) return;

                final typingEvent = _eventFromFeed(typingNotificationFeeData);
                _controller.sink.add(typingEvent);
                _removeTypingEvent(typingEvent);
              })
              .catchError((err) => print(err))
              .onError((dynamic error, stackTrace) => print(error));
        });
  }

  TypingEvent _eventFromFeed(typingNotificationFeeData) {
    return TypingEvent.fromMap(typingNotificationFeeData['new_val']);
  }

  _removeTypingEvent(TypingEvent typingEvent) {
    _rethinkDb
        .table('typing_events')
        .filter({'chatId': typingEvent.chatId})
        .delete({'return_changes': false})
        .run(_connection!);
  }

}