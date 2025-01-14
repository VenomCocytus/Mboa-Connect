import 'dart:async';

import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/models/data/local_message.dart';
import 'package:mboa_connect/src/states_management/home/chats_cubit.dart';
import 'package:mboa_connect/src/states_management/message/message_bloc.dart';
import 'package:mboa_connect/src/states_management/receipt/receipt_bloc.dart';
import 'package:mboa_connect/src/states_management/typing/typing_notification_bloc.dart';

class MessageThread extends StatefulWidget {

  final List<User> receivers;
  final User loggedUser;
  final Chat chat;
  final MessageBloc messageBloc;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatsCubit chatsCubit;

  const MessageThread(
      this.receivers,
      this.loggedUser,
      this.chat,
      this.messageBloc,
      this.typingNotificationBloc,
      this.chatsCubit
      );

  @override
  _MessageThreadState createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  
  String chatId = '';
  List<User> receivers;
  List<LocalMessage> localMessage = [];
  
  StreamSubscription _streamSubscription;
  Timer _startTypingTimer;
  Timer _stopTypingTimer;
  
  @override
  void initState() {
    super.initState();
    
    chatId = widget.chat.id;
    receivers = widget.receivers;
    receivers.removeWhere((user) => user.id == widget.loggedUser.id);

    _updateOnMessageReceived();
    _updateOnReceiptReceived();

    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.loggedUser));
    widget.typingNotificationBloc.add(TypingNotificationEvent.onSubscribe(widget.loggedUser, usersWithChat: receivers.map((user) => user.id).toList()),
    );
  }
  
  _sendReceipt(LocalMessage localMessage) async {
    
    if(localMessage.receiptStatus == ReceiptStates.read) return;
    
    final receipt = Receipt(recipient: local, messageId: messageId, status: status, timestamp: timestamp)
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _streamSubscription.cancel();
    _stopTypingTimer.cancel();
    _startTypingTimer.cancel();

    super.dispose();
  }
}