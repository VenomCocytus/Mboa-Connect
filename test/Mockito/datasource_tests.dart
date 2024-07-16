import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_connect/src/common/define/chat_type.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_sqflite_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqlite_api.dart';

class MockSqfliteDatabase extends Mock implements Database {
  @override
  Future<int> insert(String table, Map<String, dynamic> values,
      {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) {
    return Future.value(1); // Return a valid primary key value
  }
}

class MockBatch extends Mock implements Batch {}

void main() {
  late ChatRepositorySqfLiteImpl chatRepositorySqfLiteImpl;
  late MockSqfliteDatabase mockSqfLiteDatabase;

  setUp(() {
    mockSqfLiteDatabase = MockSqfliteDatabase();
    chatRepositorySqfLiteImpl = ChatRepositorySqfLiteImpl(mockSqfLiteDatabase);
  });

  test('creating a chat', () async {
    // Arrange
    final chat = Chat('1234', ChatType.individual);

    when(mockSqfLiteDatabase.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace))
        .thenAnswer((_) async => Future.value(1));

    // Act
    await chatRepositorySqfLiteImpl.createChat(chat);

    // Assert
    verify(mockSqfLiteDatabase.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });
}

