import 'package:chat/chat.dart';
import 'package:mboa_connect/src/cache/local_cache_contract.dart';
import 'package:mboa_connect/src/models/view/chats_view_model.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_contract.dart';
import 'package:mboa_connect/src/states_management/home/chats_cubit.dart';
import 'package:mboa_connect/src/states_management/message/message_bloc.dart';
import 'package:mboa_connect/src/states_management/typing/typing_notification_bloc.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:sqflite/sqflite.dart';

class CompositionRoot {
  static RethinkDb _rethinkDb;
  static Connection _connection;
  static IUserService _iUserService;
  static Database _database;
  static IMessageService _iMessageService;
  static IChatRepository _iChatRepository;
  static ILocalCache _iLocalCache;
  static MessageBloc _messageBloc;
  static ITypingNotification _typingNotification;
  static TypingNotificationBloc _typingNotificationBloc;
  static ChatsCubit _chatsCubit;
  static IGroupService _iGroupService;


  static ChatsViewModel _chatsViewModel;

}