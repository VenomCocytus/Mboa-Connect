import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_connect/src/common/define/chat_type.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/models/view/chats_view_model.dart';
import 'package:mockito/mockito.dart';

import '../../Mockito/mock_utils.dart';

void main() {
   late ChatsViewModel? chatsViewModel;
   late MockChatRepository mockChatRepository;
   late MockUserService mockUserService;

   setUp(() {
     mockChatRepository = MockChatRepository();
     mockUserService = MockUserService();
     chatsViewModel = ChatsViewModel(mockChatRepository, mockUserService);
   });

   test('Checking if there is no chats initially at launch', () async {
     when(mockChatRepository.findAllChats()).thenAnswer((_) async => []);

     expect(await chatsViewModel?.getAllChats(), isEmpty);
   });

   test('Getting a list of chats', () async {
     final chat = Chat('123', ChatType.individual);

     when(mockChatRepository.findAllChats()).thenAnswer((_) async => [chat]);
     final chats = await chatsViewModel?.getAllChats();

     expect(chats, isNotEmpty);
   });
}