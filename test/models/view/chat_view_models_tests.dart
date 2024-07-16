import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_connect/src/common/define/chat_type.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/models/data/local_message.dart';
import 'package:mboa_connect/src/models/view/chat_view_model.dart';
import 'package:mockito/mockito.dart';

import '../../Mockito/mock_utils.dart';

void main() {
  late ChatViewModel chatViewModel;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    chatViewModel = ChatViewModel(mockChatRepository);
  });

  final message = Message.fromMap({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('initial messages return empty list', () async {
    when(mockChatRepository.findAllChatMessages('')).thenAnswer((_) async => []);
    expect(await chatViewModel.getAllChatMessages('123'), isEmpty);
  });

  test('returns list of messages from local storage', () async {
    final chat = Chat('123', ChatType.individual);
    final localMessage =
    LocalMessage(chat.id, message, ReceiptStates.delivered);
    when(mockChatRepository.findAllChatMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    final messages = await chatViewModel.getAllChatMessages('123');
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '123');
  });
}