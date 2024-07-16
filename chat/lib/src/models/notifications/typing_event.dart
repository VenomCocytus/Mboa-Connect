import 'package:chat/src/common/define/typing_states.dart';

class TypingEvent {
  String? _id;
  String? chatId;
  final String? source;
  final String? destination;
  final TypingStates event;

  String? get id => _id;

  TypingEvent({
    required this.chatId,
    required this.source,
    required this.destination,
    required this.event,
  });

  Map<String, dynamic> toMap() => {
    "chatId": chatId,
    'source': source,
    'destination': destination,
    'event': event.value(),
  };

  factory TypingEvent.fromMap(Map<String, dynamic> typingEventMap) {
    var typingEvent = TypingEvent(
        chatId: typingEventMap['chatId'],
        source: typingEventMap['source'],
        destination: typingEventMap['destination'],
        event: TypingParser.fromString(typingEventMap['event']),
    );

    typingEvent._id = typingEventMap['id'];
    return typingEvent;
  }
}