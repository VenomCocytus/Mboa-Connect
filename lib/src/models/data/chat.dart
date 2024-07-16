import 'dart:convert';

import 'package:chat/chat.dart';

import '../../common/define/chat_type.dart';
import 'local_message.dart';

class Chat {
  String id;
  ChatType chatType;
  String? name;
  int unread = 0;
  List<LocalMessage>? localMessages = [];
  LocalMessage? mostRecentMessage;
  List<User>? members;
  List<Map>? memberIds;

  Chat(
      this.id,
      this.chatType,
      {
        this.memberIds,
        this.members,
        this.name,
        this.localMessages,
        this.mostRecentMessage
      });

  toMap() => {
    'id': id,
    'name': name,
    'chatType': chatType.value(),
    'members': memberIds?.map((member) => jsonEncode(member)).join(",")
  };

  factory Chat.fromMap(Map<String, dynamic> chatMap) {
    List<Map<String, dynamic>> memberIds = (chatMap['members'] as List)
        .map((member) => Map<String, dynamic>.from(member))
        .toList();
    List<User> members = memberIds.map((m) => User.fromMap(m)).toList();

    return Chat(
      chatMap['id'],
      ChatParser.fromString(chatMap['chatType']),
      memberIds: memberIds,
      members: members,
      name: chatMap['name'],
      localMessages: chatMap['localMessages'] != null
          ? (chatMap['localMessages'] as List<dynamic>)
          .map((localMessage) => LocalMessage.fromMap(localMessage))
          .toList()
          : [],
      mostRecentMessage: chatMap['mostRecentMessage'] != null
          ? LocalMessage.fromMap(chatMap['mostRecentMessage'])
          : null,
    );
  }
}