import '../../../models/user.dart';
import '../../../models/notifications/typing_event.dart';

abstract class ITypingNotification {
  Future<bool> sendNotification({required List<TypingEvent> events});
  Stream<TypingEvent> subscribeToNotification(User user, List<String> userIds);
  void dispose();
}