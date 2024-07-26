import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/common/define/chat_type.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/states_management/group_message/group_message_bloc.dart';
import 'package:mboa_connect/src/states_management/home/chats_cubit.dart';
import 'package:mboa_connect/src/states_management/message/message_bloc.dart';
import 'package:mboa_connect/src/states_management/typing/typing_notification_bloc.dart';
import 'package:mboa_connect/src/ui/pages/home/home_router.dart';
import 'package:mboa_connect/src/utils/color_generator.dart';

class ChatsWidget extends StatefulWidget {

  final User loggedUser;
  final IHomeRouter iHomeRouter;

  const ChatsWidget(this.loggedUser, this.iHomeRouter);

  @override
  State<ChatsWidget> createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {

  var chats = [];
  final typingEvents = [];

  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
    context.read<ChatsCubit>().getChats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(builder: (_, chats) {

      this.chats = chats;

      if(this.chats.isEmpty) return Container();

      List<String> usersIds = [];
      chats.forEach((chat) {
        usersIds += chat.members.map((e) => e.id).toList();
      });

      context.read<TypingNotificationBloc>().add(
        TypingNotificationEvent.onSubscribe(
            widget.loggedUser,
            usersWithChat: usersIds.toSet().toList())
      );

      return _buildListView();
    });
  }

  _buildListView() {
    return ListView.separated(
        padding: EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (_, index) => GestureDetector(
          child: _chatItem(chats[index]),
          onTap: () async {
            await this.widget.iHomeRouter.onShowMessageThread(
                context, chats[index].members, widget.loggedUser, chats[index]);

            await context.read<ChatsCubit>().getChats();
          },
        ),
        separatorBuilder: (_, __) => Divider(),
        itemCount: chats.length);
  }

  _updateChatsOnMessageReceived() {

    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((messageState) async {
      if (messageState is MessageReceivedSuccessfully) {
        await chatsCubit.chatsViewModel.deliverMessage(messageState.message);
        chatsCubit.getChats();
      }
    });

    context.read<GroupMessageBloc>().stream.listen((groupMessageState) async {
      if (groupMessageState is GroupMessageReceived) {
        final group = groupMessageState.groupMessage;
        group.members.removeWhere((e) => e == widget.loggedUser.id);
        final membersId = group.members
            .map((e) => {e: RandomColorGenerator.getColor().value.toString()})
            .toList();
        final chat = Chat(group.id ?? '', ChatType.group,
            name: group.name, memberIds: membersId);
        await chatsCubit.chatsViewModel.createNewChat(chat);
        chatsCubit.getChats();
      }
    });
}

