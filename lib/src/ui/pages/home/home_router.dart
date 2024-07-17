import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:mboa_connect/src/models/data/chat.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(
      BuildContext context, List<User> receivers, User loggedUser, Chat chat
      );

  Future<void> onShowCreatedGroup(
      BuildContext context, List<User> activeUsers, User loggedUser
      );
}