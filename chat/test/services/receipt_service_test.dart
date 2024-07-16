import 'package:chat/src/common/define/receipt_states.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import '../helper.dart';

void main() {
  RethinkDb rethinkDb = RethinkDb();
  Connection? connection;
  late ReceiptService receiptService;
  
  setUp(() async {
    connection = await rethinkDb.connect();
    await createDB(rethinkDb, connection!);
    receiptService = ReceiptService(rethinkDb, connection);
  });
  
  tearDown(() async {
    receiptService.dispose();
    await cleanDB(rethinkDb, connection!);
  });

  final user = User.fromMap({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  test("Send receipt successfully", () async {
    Receipt receipt = Receipt(
      recipient: '444',
      messageId: '2341',
      status: ReceiptStates.delivered,
      timestamp: DateTime.now()
    );

    final result = await receiptService.sendReceipt(receipt);
    expect(result, true);
  });

  test("Successfully login and receiving receipts", () async {
    receiptService.getReceipts(user).listen(expectAsync1((receipt) {
      expect(receipt.recipient, user.id);
    }, count: 2));

    Receipt receipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStates.delivered,
        timestamp: DateTime.now());

    Receipt anotherReceipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStates.read,
        timestamp: DateTime.now());

    await receiptService.sendReceipt(receipt);
    await receiptService.sendReceipt(anotherReceipt);
  });

}