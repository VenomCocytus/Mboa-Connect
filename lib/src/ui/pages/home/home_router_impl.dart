import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/ui/pages/home/home_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeRouter implements IHomeRouter {

  final Widget Function(List<User> receivers, User loggedUser, Chat chat) showMessageThread;
  final Widget Function(List<User> activeUsers, User loggedUser) showCreatedGroup;

  HomeRouter({
    required this.showMessageThread,
    required this.showCreatedGroup
  });

  @override
  Future<void> onShowCreatedGroup(BuildContext context, List<User> activeUsers, User loggedUser) async {

    showCupertinoModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => showCreatedGroup(activeUsers, loggedUser),
    );
  }

  @override
  Future<void> onShowMessageThread(BuildContext context, List<User> receivers, User loggedUser, Chat chat) {

    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => showMessageThread(receivers, loggedUser, chat
            )
        )
    );
  }}