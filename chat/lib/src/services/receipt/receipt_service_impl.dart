import 'dart:async';

import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class ReceiptService implements IReceiptService {
  final Connection? _connection;
  final RethinkDb rethinkDb;

  final _controller = StreamController<Receipt>.broadcast();
  StreamSubscription? _changeFeed;

  ReceiptService(this.rethinkDb, this._connection);

  @override
  void dispose() {
    _changeFeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Receipt> getReceipts(User user) {
    _startReceivingReceipts(user);

    return _controller.stream;
  }

  @override
  Future<bool> sendReceipt(Receipt receipt) async {
    var data = receipt.toMap();
    Map record = await (
        rethinkDb
            .table('receipts')
            .insert(data)
            .run(_connection!));

    return record['inserted'] == 1;
  }

  _startReceivingReceipts(User user) {
    _changeFeed = rethinkDb
        .table('receipts')
        .filter({'recipient': user.id})
        .changes({'include_initial': true})
        .run(_connection!)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((receiptFeedData) {
                if(receiptFeedData['new_val'] == null) return;

                final receipt = _receiptFromFeed(receiptFeedData);
                _removeDeliveredReceipt(receipt);
                _controller.sink.add(receipt);
              })
              .catchError((err) => print(err))
              .onError((dynamic error, stackTrace) => print(error));
        });
  }

  Receipt _receiptFromFeed(receiptFeedData) {
    var data = receiptFeedData['new_val'];

    return Receipt.fromMap(data);
  }

  _removeDeliveredReceipt(Receipt receipt){
    rethinkDb
        .table('receipts')
        .get(receipt.id)
        .delete({'return_changes': false})
        .run(_connection!);
  }
  
}