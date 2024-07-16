import 'package:chat/chat.dart';
import 'package:mboa_connect/src/models/data/local_message.dart';
import 'package:mboa_connect/src/models/view/base_view_model.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_contract.dart';

class ChatViewModel extends BaseViewModel {
  final IChatRepository _iChatRepository;
  String _chatId = '';
  int newMessages = 0;

  String get chatId => _chatId;

  ChatViewModel(this._iChatRepository) : super(_iChatRepository);

  Future<List<LocalMessage>> getAllChatMessages(String chatId) async {
    final localMessages = await _iChatRepository.findAllChatMessages(chatId);
    if(localMessages.isNotEmpty) _chatId = chatId;

    return localMessages;
  }

  Future<void> sendChatMessage(Message message) async {
    final chatId = message.groupId ?? message.destination;
    LocalMessage localMessage = LocalMessage(chatId!, message, ReceiptStates.sent);

    if(_chatId.isNotEmpty) return await _iChatRepository.createChatMessage(localMessage);
    _chatId = localMessage.chatId;

    await createChatMessage(localMessage);
  }

  Future<void> deliverChatMessage(Message message) async {
    final chatId = message.groupId ?? message.destination;
    LocalMessage localMessage = LocalMessage(chatId!, message, ReceiptStates.delivered);

    if(_chatId.isEmpty) _chatId = localMessage.chatId;
    if(localMessage.chatId != _chatId) newMessages++;

    await createChatMessage(localMessage);
  }
  
  Future<void> updateChatMessageReceipt(Receipt receipt) async {
    await _iChatRepository.updateChatMessageReceipt(receipt.messageId!, receipt.status);
  }
}