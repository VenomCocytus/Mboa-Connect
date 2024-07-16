class User {
  String? _id;
  String? _username;
  String? firstName;
  String? lastName;
  String? photoUrl;
  bool? active;
  DateTime? lastSeen;

  String? get id => _id;
  String? get username => _username;

  User({
        required this.firstName,
        required this.lastName,
        required this.photoUrl,
        required this.active,
        required this.lastSeen
  });

  toMap() => {
    'username': username,
    'photoUrl': photoUrl,
    'active': active,
    'lastSeen': lastSeen
  };

  factory User.fromMap(Map<String, dynamic> userMap) {
    final user = User(
        firstName: userMap['firstName'],
        lastName: userMap['lastName'],
        photoUrl: userMap['photoUrl'],
        active: userMap['active'],
        lastSeen: userMap['lastSeen']
    );

    user._id = userMap['id'];
    user._username = '${user.firstName}_${user.lastName}'.toLowerCase();
    return user;
  }
}