import 'package:flutter/cupertino.dart';
import 'package:mboa_connect/src/common/define/chat_type.dart';

import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_contract.dart';

import '../data/chat.dart';
import '../data/local_message.dart';

abstract class BaseViewModel {
  final IChatRepository _iChatRepository;

  BaseViewModel(this._iChatRepository);

  @protected
  Future<void> createChatMessage(LocalMessage localMessage) async {
    if(!await _isExistingChat(localMessage.chatId)) {
      final chat = Chat(
          localMessage.chatId,
          ChatType.individual,
          memberIds: [{
            localMessage.chatId: ""
          }]
      );
      await createNewChat(chat);
    }

    await _iChatRepository.createChatMessage(localMessage);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _iChatRepository.findChat(chatId) != null;
  }

  Future<void> createNewChat(Chat chat) async {
    await _iChatRepository.createChat(chat);
  }
}