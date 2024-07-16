import 'package:chat/chat.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/models/data/local_message.dart';
import 'package:mboa_connect/src/models/view/base_view_model.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_contract.dart';

class ChatsViewModel extends BaseViewModel {
  final IChatRepository _iChatRepository;
  final IUserService _iUserService;

  ChatsViewModel(this._iChatRepository, this._iUserService) : super(_iChatRepository);

  Future<List<Chat>> getAllChats() async {
    final chatList = await _iChatRepository.findAllChats();

    await Future.forEach(chatList, (Chat chat) async {
      final ids = chat.memberIds!.map<String>((id) => id.keys.first).toList();
      final users = await _iUserService.getAllUsers(ids);
      chat.members = users;
    });

    return chatList;
  }

  Future<void> deliverMessage(Message message) async {
    final chatId = message.groupId ?? message.source;
    LocalMessage localMessage = LocalMessage(chatId!, message, ReceiptStates.delivered);

    await createChatMessage(localMessage);
  }
}