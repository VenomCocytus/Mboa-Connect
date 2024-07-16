enum ChatType { individual, group }

extension ChatParser on ChatType {
  String value() {
    return toString().split('.').last;
  }

  static ChatType fromString(String status) {
    return ChatType.values.firstWhere((element) => element.value() == status);
  }
}