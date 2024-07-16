import 'package:bloc/bloc.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/models/view/chat_view_model.dart';
import 'package:mboa_connect/src/models/view/chats_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {

  final ChatsViewModel chatsViewModel;

  ChatsCubit(this.chatsViewModel) : super([]);

  Future<void> chats() async {

    final chats = await chatsViewModel.getAllChats();

    emit(chats);
  }
}