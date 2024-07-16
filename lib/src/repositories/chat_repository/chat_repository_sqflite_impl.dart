import 'package:chat/chat.dart';
import 'package:mboa_connect/src/repositories/chat_repository/chat_repository_contract.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/data/chat.dart';
import '../../models/data/local_message.dart';

class ChatRepositorySqfLiteImpl implements IChatRepository {
  final Database _database;

  const ChatRepositorySqfLiteImpl(this._database);

  @override
  Future<void> createChat(Chat chat) async {
    await _database.transaction((txn) async {
      await txn.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<void> createChatMessage(LocalMessage localMessage) async {
    await _database.transaction((txn) async {
      await txn.insert('messages', localMessage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
      await txn.update('chats', {'updateAt': localMessage.message.timestamp.toString()},
        where: 'id = ?', whereArgs: [localMessage.chatId]);
    });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _database.batch();
    batch.delete('messages', where: 'chatId = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<LocalMessage>> findAllChatMessages(String chatId) async {
    final chatMessageMaps = await _database.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
    );

    return chatMessageMaps
        .map<LocalMessage>((chatMap) => LocalMessage.fromMap(chatMap))
        .toList();
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _database.transaction((txn) async {
      final chatMap =
        await txn.query(
          'chats',
          orderBy: 'updated_at DESC'
      );

      if (chatMap.isEmpty) return [];

      return await Future.wait(chatMap.map<Future<Chat>>((chatRow) async {
        final unreadMessages = Sqflite.firstIntValue(
            await txn
                .rawQuery(
                  'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
                  [chatRow['id'], 'delivered']
            ));

        final mostRecentMessage = await txn
            .query('messages',
                where: 'chat_id = ?',
                whereArgs: [chatRow['id']],
                orderBy: 'created_at DESC',
                limit: 1
            );

        final searchedChat = Chat.fromMap(chatRow);
        searchedChat.unread = unreadMessages!;

        if (mostRecentMessage.isNotEmpty) {
          searchedChat.mostRecentMessage = LocalMessage.fromMap(mostRecentMessage.first);
        }

        return searchedChat;
      }));
    });
  }

  @override
  Future<Chat?> findChat(String chatId) async {
    return await _database.transaction((txn) async {
      final chatMapList = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if(chatMapList.isEmpty) return null;

      final unreadMessages = Sqflite.firstIntValue(
          await txn
              .rawQuery(
                'SELECT COUNT(*) FROM MESSAGES WHERE chatIid = ? AND receipt = ?',
                [chatId, 'delivered']
          ));

      final mostRecentMessage = await txn.query(
        'messages',
        where: 'chatId = ?',
        whereArgs: [chatId],
        orderBy: 'createAt DESC',
        limit: 1
      );

      final searchedChat = Chat.fromMap(chatMapList.first);
      searchedChat.unread = unreadMessages!;

      if(mostRecentMessage.isNotEmpty) {
        searchedChat.mostRecentMessage = LocalMessage.fromMap(mostRecentMessage.first);
      }

      return searchedChat;
    });
  }

  @override
  Future<void> updateChatMessage(LocalMessage localMessage) async {
    await _database.update('messages', localMessage.toMap(),
        where: 'id = ?',
        whereArgs: [localMessage.message.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Future<void> updateChatMessageReceipt(String messageId, ReceiptStates state) {
    return _database.transaction((txn) async {
      await txn.update('messages', {'receipt': state.value()},
        where: 'id = ?',
      whereArgs: [messageId],
      conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
  
}