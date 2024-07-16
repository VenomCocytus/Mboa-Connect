import 'package:chat/src/models/messages/message.dart';
import '../../models/user.dart';

abstract class IMessageService {
  Future<Message> sendMessages(List<Message> messages);
  Stream<Message> getAllMessages({required User activeUser});
  dispose();
}