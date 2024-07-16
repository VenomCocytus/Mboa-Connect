class GroupMessage {
  String? _id;
  String? name;
  String? createdBy;
  List<String> members;

  String? get id => _id;

  GroupMessage({
    required this.createdBy,
    required this.name,
    required this.members,
  });

  toMap() => {
    'createdBy': this.createdBy,
    'name': this.name,
    'members': this.members,
  };

  factory GroupMessage.fromMap(Map<String, dynamic> groupMessageMap) {
    var groupMessage = GroupMessage(
        createdBy: groupMessageMap['createdBy'],
        name: groupMessageMap['name'],
        members: List<String>.from(groupMessageMap['members']));
    groupMessage._id = groupMessageMap['id'];

    return groupMessage;
  }
}