part of 'receipt_bloc.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();
  factory ReceiptState.initialization() => ReceiptInitialization();
  factory ReceiptState.sent(Receipt receipt) => ReceiptSentSuccessfully(receipt);
  factory ReceiptState.received(Receipt receipt) => ReceiptReceivedSuccessfully(receipt);

  @override
  List<Object> get props => [];
 }

class ReceiptInitialization extends ReceiptState {}

class ReceiptSentSuccessfully extends ReceiptState {
  final Receipt receipt;
  const ReceiptSentSuccessfully(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class ReceiptReceivedSuccessfully extends ReceiptState {
  final Receipt receipt;
  const ReceiptReceivedSuccessfully(this.receipt);

  @override
  List<Object> get props => [receipt];
}