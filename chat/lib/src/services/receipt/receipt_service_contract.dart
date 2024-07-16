import 'package:chat/src/models/receipt.dart';

import '../../models/user.dart';

abstract class IReceiptService {
  Future<bool> sendReceipt(Receipt receipt);
  Stream<Receipt> getReceipts(User user);
  void dispose();
}