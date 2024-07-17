part of 'group_message_bloc.dart';

abstract class GroupMessageEvent extends Equatable {

  const GroupMessageEvent();
  
  factory GroupMessageEvent.onSubscribe(User userToSubscribe) => Subscribe(userToSubscribe);
  factory GroupMessageEvent.onGroupMessageCreated(GroupMessage groupMessage) =>
      GroupMessageCreated(groupMessage);

  @override
  List<Object> get props => [];
}

class Subscribe extends GroupMessageEvent {

  final User subscribedUser;

  const Subscribe(this.subscribedUser);

  @override
  List<Object> get props => [subscribedUser];
}

class GroupMessageCreated extends GroupMessageEvent {

  final GroupMessage groupMessage;

  const GroupMessageCreated(this.groupMessage);

  @override
  List<Object> get props => [groupMessage];
}

class _GroupMessageReceived extends GroupMessageEvent {

  const _GroupMessageReceived(this.groupMessage);

  final GroupMessage groupMessage;

  @override
  List<Object> get props => [groupMessage];
}