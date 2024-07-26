import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/cache/local_cache.dart';
import 'package:mboa_connect/src/cache/local_cache_contract.dart';
import 'package:mboa_connect/src/factories/database_factory.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/models/view/chat_view_model.dart';
import 'package:mboa_connect/src/models/view/chats_view_model.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_contract.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_sqflite_impl.dart';
import 'package:mboa_connect/src/services/image_uploader.dart';
import 'package:mboa_connect/src/states_management/group_message/group_message_bloc.dart';
import 'package:mboa_connect/src/states_management/home/chats_cubit.dart';
import 'package:mboa_connect/src/states_management/home/home_cubit.dart';
import 'package:mboa_connect/src/states_management/message/message_bloc.dart';
import 'package:mboa_connect/src/states_management/message_thread/message_thread_cubit.dart';
import 'package:mboa_connect/src/states_management/onboarding/onboarding_cubit.dart';
import 'package:mboa_connect/src/states_management/onboarding/profile_picture_cubit.dart';
import 'package:mboa_connect/src/states_management/receipt/receipt_bloc.dart';
import 'package:mboa_connect/src/states_management/typing/typing_notification_bloc.dart';
import 'package:mboa_connect/src/ui/pages/home/home.dart';
import 'package:mboa_connect/src/ui/pages/home/home_router.dart';
import 'package:mboa_connect/src/ui/pages/home/home_router_impl.dart';
import 'package:mboa_connect/src/ui/pages/onboarding/onboarding.dart';
import 'package:mboa_connect/src/ui/pages/onboarding/onboarding_router.dart';
import 'package:mboa_connect/src/ui/pages/onboarding/onboarding_router_impl.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static ITypingNotification _iTypingNotification;
  static TypingNotificationBloc _typingNotificationBloc;
  static ChatsCubit _chatsCubit;
  static IGroupService _iGroupService;
  static GroupMessageBloc _groupMessageBloc;
  static IHomeRouter _iHomeRouter;
  static ChatsViewModel _chatsViewModel;

  static setup() async {
    _rethinkDb = RethinkDb();
    _connection = await _rethinkDb.connect(host: '127.0.0.1', port: 28015);
    _iUserService = UserService(_rethinkDb, _connection);
    _iMessageService = MessageService(_rethinkDb, _connection);
    _iTypingNotification = TypingNotificationService(_rethinkDb, _connection, _iUserService);

    _database = await LocalDatabaseFactory().createDatabase();
    _iChatRepository = ChatRepositorySqfLiteImpl(_database);

    _messageBloc = MessageBloc(_iMessageService);
    _typingNotificationBloc = TypingNotificationBloc(_iTypingNotification);

    _chatsViewModel = ChatsViewModel(_iChatRepository, _iUserService);
    _chatsCubit = ChatsCubit(_chatsViewModel);

    _iGroupService = GroupMessageService(_rethinkDb, _connection);
    _groupMessageBloc = GroupMessageBloc(_iGroupService);

    final sharedPreferences = await SharedPreferences.getInstance();
    _iLocalCache = LocalCache(sharedPreferences);

    _iHomeRouter = HomeRouter(
        showMessageThread: composeMessageThreadUi,
        showCreatedGroup: composeGroupUi
    );

    _database.delete('chats');
    _database.delete('messages');
  }

  static Widget start() {

    final userMap = _iLocalCache.fetch('User');

    return userMap.isEmpty
        ? composeOnboardingUi()
        : composeHomeUi(User.fromMap(userMap)
    );
  }

  static Widget composeOnboardingUi() {

    ImageUploader imageUploader = ImageUploader('http://localhost:3000/upload');

    OnboardingCubit onboardingCubit =
        OnboardingCubit(_iUserService, imageUploader, _iLocalCache);

    ProfilePictureCubit profilePictureCubit = ProfilePictureCubit();
    IOnboardingRouter iOnboardingRouter = OnboardingRouter(composeHomeUi);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => onboardingCubit),
          BlocProvider(create: (BuildContext context) => profilePictureCubit),
        ],
        child: Onboarding(iOnboardingRouter),
    );
  }

  static Widget composeHomeUi(User loggedUser) {

    HomeCubit homeCubit = HomeCubit(_iUserService, _iLocalCache);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => homeCubit),
          BlocProvider(create: (BuildContext context) => _messageBloc),
          BlocProvider(create: (BuildContext context) => _typingNotificationBloc),
          BlocProvider(create: (BuildContext context) => _chatsCubit),
          BlocProvider(create: (BuildContext context) => _groupMessageBloc)
        ],
        child: Home(loggedUser: loggedUser, iHomeRouter: _iHomeRouter, chatsViewModel: _chatsViewModel)
    );
  }

  static Widget composeMessageThreadUi(List<User> receivers, User loggedUser, Chat chat) {

    ChatViewModel chatViewModel = ChatViewModel(_iChatRepository);
    MessageThreadCubit messageThreadCubit = MessageThreadCubit(chatViewModel);
    IReceiptService iReceiptService = ReceiptService(_rethinkDb, _connection);
    ReceiptBloc receiptBloc = ReceiptBloc(iReceiptService);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => messageThreadCubit),
          BlocProvider(create: (BuildContext context) => receiptBloc)
        ],
        child: MessageThre
    );
  }

}