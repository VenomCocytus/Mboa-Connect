import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageService _iMessageService;
  StreamSubscription<Message>? _streamSubscription;

  MessageBloc(this._iMessageService) : super(MessageState.initialization());

  Stream<MessageState> mapEventToState(MessageEvent messageEvent) async* {
    if (messageEvent is Subscribe) {
      await _streamSubscription?.cancel();
      _streamSubscription = _iMessageService
          .getAllMessages(activeUser: messageEvent.user)
          .listen((message) => add(_MessageReceived(message)));
    }

    if (messageEvent is _MessageReceived) {
      yield MessageState.received(messageEvent.message);
    }

    if (messageEvent is MessageSent) {
      final message = await _iMessageService.sendMessages(messageEvent.messages);
      yield MessageState.sent(message);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _iMessageService.dispose();

    return super.close();
  }
}

