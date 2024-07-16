enum TypingStates { start, stop }

extension TypingParser on TypingStates {
  String value() {
    return toString().split('.').last;
  }

  static TypingStates fromString(String? event) {
    return TypingStates
        .values
        .firstWhere((element) => element.value() == event);
  }
}