import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat/chat.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IReceiptService _iReceiptService;
  StreamSubscription? _streamSubscription;

  ReceiptBloc(this._iReceiptService) : super(ReceiptState.initialization());

  Stream<ReceiptState> mapEventToState(ReceiptEvent receiptEvent) async* {
    if (receiptEvent is Subscribe) {
      await _streamSubscription?.cancel();
      _streamSubscription = _iReceiptService
          .getReceipts(receiptEvent.user)
          .listen((receipt) => add(_ReceiptReceived(receipt)));
    }

    if (receiptEvent is _ReceiptReceived) {
      yield ReceiptState.received(receiptEvent.receipt);
    }

    if (receiptEvent is ReceiptSent) {
      yield ReceiptState.sent(receiptEvent.receipt);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _iReceiptService.dispose();

    return super.close();
  }
}