import 'package:chat/chat.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_contract.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mockito/mockito.dart';

class MockSqfLiteDatabase extends Mock implements Database {}

class MockBatch extends Mock implements Batch {}

class MockChatRepository extends Mock implements IChatRepository {}

class MockUserService extends Mock implements IUserService {}