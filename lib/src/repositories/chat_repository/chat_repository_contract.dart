import 'package:chat/chat.dart';

import '../../models/data/chat.dart';
import '../../models/data/local_message.dart';

abstract class IChatRepository {
  Future<void> createChat(Chat chat);
  Future<void> deleteChat(String chatId);

  Future<Chat?> findChat(String chatId);
  Future<List<Chat>> findAllChats();

  Future<void> createChatMessage(LocalMessage localMessage);
  Future<void> updateChatMessage(LocalMessage localMessage);
  Future<List<LocalMessage>> findAllChatMessages(String chatId);
  Future<void> updateChatMessageReceipt(String messageId, ReceiptStates state);

}