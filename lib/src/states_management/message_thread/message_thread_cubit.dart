import 'package:bloc/bloc.dart';
import 'package:mboa_connect/src/models/data/local_message.dart';
import 'package:mboa_connect/src/models/view/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {

  final ChatViewModel chatViewModel;

  MessageThreadCubit(this.chatViewModel) : super([]);

  Future<void> messages(String chatId) async {

    final messages = await chatViewModel.getAllChatMessages(chatId);
    emit(messages);
  }
}