part of 'typing_notification_bloc.dart';

abstract class TypingNotificationEvent extends Equatable {
  const TypingNotificationEvent();
  factory TypingNotificationEvent.onSubscribe(User user,
      {required List<String> usersWithChat}) =>
      Subscribe(user, usersWithChat: usersWithChat);
  factory TypingNotificationEvent.onTypingEventSent(List<TypingEvent> typingEvents) =>
      TypingNotificationSent(typingEvents);

  @override
  List<Object> get props => [];
}

class Subscribe extends TypingNotificationEvent {
  final User user;
  final List<String> usersWithChat;
  const Subscribe(this.user, {required this.usersWithChat});

  @override
  List<Object> get props => [user, usersWithChat];
}

class NotSubscribe extends TypingNotificationEvent {}

class TypingNotificationSent extends TypingNotificationEvent {
  final List<TypingEvent> typingEvents;
  const TypingNotificationSent(this.typingEvents);

  @override
  List<Object> get props => [typingEvents];
}

class _TypingNotificationReceived extends TypingNotificationEvent {
  const _TypingNotificationReceived(this.typingEvent);

  final TypingEvent typingEvent;

  @override
  List<Object> get props => [typingEvent];
}
