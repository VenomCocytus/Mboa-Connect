import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_connect/src/common/define/chat_type.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/models/data/local_message.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_sqflite_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import '../Mockito/mock_utils.dart';

void main() {
  late ChatRepositorySqfLiteImpl chatRepositorySqfLiteImpl;
  late MockSqfLiteDatabase mockSqfLiteDatabase;
  late MockBatch mockBatch;

  setUp(() {
      mockSqfLiteDatabase = MockSqfLiteDatabase();
      mockBatch = MockBatch();
      chatRepositorySqfLiteImpl = ChatRepositorySqfLiteImpl(mockSqfLiteDatabase);
  });

  // Creating a message
  final message = Message.fromMap({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('creating a chat', () async {
    // Arrange
    final chat = Chat('1234', ChatType.individual);

    when(mockSqfLiteDatabase.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    // Act
    await chatRepositorySqfLiteImpl.createChat(chat);

    // Assert
    verify(mockSqfLiteDatabase.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace))
    .called(1);
  });

  test('creating a chat message', () async {
    // Arrange
    final localMessage = LocalMessage('1234', message, ReceiptStates.sent);

    when(mockSqfLiteDatabase.insert('messages', localMessage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => 1);

    // Act
    await chatRepositorySqfLiteImpl.createChatMessage(localMessage);

    // Assert
    verify(mockSqfLiteDatabase.insert('messages', localMessage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('finding all messages of a specific chat', () async {
    // Arrange
    final messagesMap = [
      {
        'chat_id': '111',
        'id': '4444',
        'from': '111',
        'to': '222',
        'contents': 'hey',
        'receipt': 'sent',
        'timestamp': DateTime.parse("2021-04-01"),
      },
      {
        'chat_id': '111',
        'id': '5555',
        'from': '111',
        'to': '222',
        'contents': 'hey2',
        'receipt': 'sent',
        'timestamp': DateTime.parse("2021-04-02"),
      }
    ];

    when(mockSqfLiteDatabase.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => messagesMap);

    // Act
    var gotMessages = await chatRepositorySqfLiteImpl.findAllChatMessages('111');

    // Assert
    expect(gotMessages.length, 2);
    expect(gotMessages.first.chatId, '111');
    verify(mockSqfLiteDatabase
        .query('messages',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
    )).called(2);
  });

  test('Updating a chat message', () async {
    // Arrange
    final localMessage = LocalMessage('1234', message, ReceiptStates.sent);

    when(mockSqfLiteDatabase.update(
          'messages',
          localMessage.toMap(),
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs')))
        .thenAnswer((_) async => 1);

    // Act
    await chatRepositorySqfLiteImpl.updateChatMessage(localMessage);

    // Assert
    verify(mockSqfLiteDatabase.update(
          'messages',
          localMessage.toMap(),
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
          conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('batch deleting a chat', () async {
    // Arrange
    const chatId = '111';

    when(mockSqfLiteDatabase.batch()).thenReturn(mockBatch);

    // Act
    await chatRepositorySqfLiteImpl.deleteChat(chatId);

    // Assert
    verifyInOrder([
      mockSqfLiteDatabase.batch(),
      mockBatch.delete('messages', where: anyNamed('where'), whereArgs: [chatId]),
      mockBatch.delete('chats', where: anyNamed('where'), whereArgs: [chatId]),
      mockBatch.commit(noResult: true)
    ]);
  });

}