import '../common/define/receipt_states.dart';

class Receipt {
  String? _id;
  final String? recipient;
  final String? messageId;
  final ReceiptStates status;
  final DateTime? timestamp;

  String? get id => _id;

  Receipt({
    required this.recipient,
    required this.messageId,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'recipient': recipient,
    'messageId': messageId,
    'status': status.value(),
    'timestamp': timestamp
  };

  factory Receipt.fromMap(Map<String, dynamic> receiptMap) {
    var receipt = Receipt(recipient: receiptMap['recipient'],
        messageId: receiptMap['messageId'],
        status: StateParser.fromString(receiptMap['status']),
        timestamp: receiptMap['timestamp']);
    receipt._id = receiptMap['id'];
    return receipt;
  }
}