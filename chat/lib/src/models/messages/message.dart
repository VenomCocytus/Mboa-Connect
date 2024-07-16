class Message {
  String? _id;
  String? groupId;
  final String? source;
  final String? destination;
  final DateTime? timestamp;
  final String? contents;

  String? get id => _id;

  Message({
    required this.source,
    required this.destination,
    required this.timestamp,
    required this.contents,
    this.groupId,
  });

  toMap() => {
    'source': source,
    'destination': destination,
    'timestamp': timestamp,
    'contents': contents,
    'groupId': groupId
  };

  factory Message.fromMap(Map<String, dynamic> messageMap) {
    var message = Message(
        source: messageMap['source'],
        destination: messageMap['destination'],
        timestamp: messageMap['timestamp'],
        contents: messageMap['contents'],
        groupId: messageMap['groupId']
    );

    message._id = messageMap['id'];
    return message;
  }

}