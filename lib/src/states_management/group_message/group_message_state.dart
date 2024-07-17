part of 'group_message_bloc.dart';

abstract class GroupMessageState extends Equatable {

  const GroupMessageState();

  factory GroupMessageState.initialization() => GroupMessageInitialization();
  factory GroupMessageState.created(GroupMessage groupMessage) =>
      GroupMessageCreatedSuccessfully(groupMessage);
  factory GroupMessageState.received(GroupMessage groupMessage) =>
      GroupMessageReceived(groupMessage);

  @override
  List<Object> get props => [];
}

class GroupMessageInitialization extends GroupMessageState {}

class GroupMessageCreatedSuccessfully extends GroupMessageState {
   const GroupMessageCreatedSuccessfully(this.groupMessage);

   final GroupMessage groupMessage;

   @override
   List<Object> get props => [groupMessage];
}

class GroupMessageReceived extends GroupMessageState {
  const GroupMessageReceived(this.groupMessage);

  final GroupMessage groupMessage;

  @override
  List<Object> get props => [groupMessage];
}