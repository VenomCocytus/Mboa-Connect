import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

part 'group_message_event.dart';
part 'group_message_state.dart';

class GroupMessageBloc extends Bloc<GroupMessageEvent, GroupMessageState> {

  GroupMessageBloc(this._iGroupService) : super(GroupMessageState.initialization());

  final IGroupService _iGroupService;
  StreamSubscription? _streamSubscription;

  Stream<GroupMessageState> mapEventToState(GroupMessageEvent groupMessageEvent) async* {
    if(groupMessageEvent is Subscribe) {
      await _streamSubscription?.cancel();
      _streamSubscription = _iGroupService
          .getGroupMessages(loggedUser: groupMessageEvent.subscribedUser)
          .listen((groupMessage) => add(_GroupMessageReceived(groupMessage)));
    }

    if(groupMessageEvent is _GroupMessageReceived) {
      yield GroupMessageState.received(groupMessageEvent.groupMessage);
    }

    if(groupMessageEvent is GroupMessageCreated) {
      final groupMessage = await _iGroupService.sendGroupMessage(groupMessageEvent.groupMessage);
      yield GroupMessageState.created(groupMessage);
    }
  }

  @override
  Future<void> close() {
    print('Dispose called');
    _streamSubscription?.cancel();
    _iGroupService.dispose();

    return super.close();
  }
}
