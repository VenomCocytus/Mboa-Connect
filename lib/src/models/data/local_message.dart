import 'package:chat/chat.dart';

class LocalMessage {
  String? _id;
  String chatId;
  Message message;
  ReceiptStates receiptStatus;

  String? get id => _id;

  LocalMessage(this.chatId, this.message, this.receiptStatus);

  Map<String, dynamic> toMap() => {
    "chatId": chatId,
    "id": message.id,
    'sender': message.source,
    'receiver': message.destination,
    'contents': message.contents,
    'receipt': receiptStatus.value(),
    'receive_at': message.timestamp.toString()
  };

  factory LocalMessage.fromMap(Map<String, dynamic> localMessageMap) {
    final message = Message(
      source: localMessageMap['sender'],
      destination: localMessageMap['receiver'],
      contents: localMessageMap['contents'],
      timestamp: DateTime.parse(localMessageMap['receivedAt'])
    );

    final localMessage = LocalMessage(
      localMessageMap['chatId'],
      message,
      StateParser.fromString(localMessageMap['receipt'])
    );
    localMessage._id = localMessageMap['id'];

    return localMessage;
  }
}