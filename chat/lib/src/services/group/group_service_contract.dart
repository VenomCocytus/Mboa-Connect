import 'package:chat/chat.dart';

abstract class IGroupService {
  Future<GroupMessage> sendGroupMessage(GroupMessage groupMessage);
  Stream<GroupMessage> getGroupMessages({required User loggedUser});
  dispose();
}