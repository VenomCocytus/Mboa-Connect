part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  factory MessageState.initialization() => MessageInitialization();
  factory MessageState.sent(Message message) => MessageSentSuccessfully(message);
  factory MessageState.received(Message message) => MessageReceivedSuccessfully(message);

  @override
  List<Object> get props => [];
}

class MessageInitialization extends MessageState {
}

class MessageSentSuccessfully extends MessageState {
  final Message message;
  const MessageSentSuccessfully(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceivedSuccessfully extends MessageState {
  final Message message;
  const MessageReceivedSuccessfully(this.message);

  @override
  List<Object> get props => [message];
}