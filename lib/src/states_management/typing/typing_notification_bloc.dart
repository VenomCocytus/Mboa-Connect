import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'typing_notification_event.dart';
part 'typing_notification_state.dart';

class TypingNotificationBloc
    extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  final ITypingNotification _iTypingNotification;
  StreamSubscription? _streamSubscription;

  TypingNotificationBloc(this._iTypingNotification)
      : super(TypingNotificationState.initialization());

  Stream<TypingNotificationState> mapEventToState(
      TypingNotificationEvent typingEvent) async* {
    if (typingEvent is Subscribe) {
      if (typingEvent.usersWithChat == null) {
        add(NotSubscribe());
        return;
      }

      await _streamSubscription?.cancel();
      _streamSubscription = _iTypingNotification
          .subscribeToNotification(typingEvent.user, typingEvent.usersWithChat)
          .listen(
              (typingEvent) => add(_TypingNotificationReceived(typingEvent)));
    }

    if (typingEvent is _TypingNotificationReceived) {
      yield TypingNotificationState.received(typingEvent.typingEvent);
    }
    if (typingEvent is TypingNotificationSent) {
      await _iTypingNotification.sendNotification(events: typingEvent.typingEvents);
      yield TypingNotificationState.sent();
    }

    if (typingEvent is NotSubscribe) {
      yield TypingNotificationState.initialization();
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _iTypingNotification.dispose();
    return super.close();
  }
}
