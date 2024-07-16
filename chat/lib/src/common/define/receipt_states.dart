enum ReceiptStates {
  sent,
  delivered,
  read
}

extension StateParser on ReceiptStates {
  String value() {
    return toString().split(".").last;
  }

  static ReceiptStates fromString(String status) {
    return ReceiptStates.values.firstWhere((element) =>
      element.value() == status
    );
  }
}