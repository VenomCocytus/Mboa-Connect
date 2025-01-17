part of 'typing_notification_bloc.dart';

abstract class TypingNotificationState extends Equatable {
  const TypingNotificationState();
  factory TypingNotificationState.initialization() => TypingNotificationInitialization();
  factory TypingNotificationState.sent() => TypingNotificationSentSuccess();
  factory TypingNotificationState.received(TypingEvent typingEvent) =>
      TypingNotificationReceivedSuccess(typingEvent);

  @override
  List<Object> get props => [];
}

class TypingNotificationInitialization extends TypingNotificationState {}

class TypingNotificationSentSuccess extends TypingNotificationState {}

class TypingNotificationReceivedSuccess extends TypingNotificationState {
  final TypingEvent typingEvent;
  const TypingNotificationReceivedSuccess(this.typingEvent);

  @override
  List<Object> get props => [typingEvent];
}
