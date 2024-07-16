import 'dart:async';

import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mboa_connect/src/states_management/message/message_bloc.dart';
import 'package:mockito/mockito.dart';

class FakeMessageService extends Mock implements IMessageService {
  @override
  Stream<Message> getAllMessages({User? activeUser}) {
    return const Stream.empty();
  }
}

void main() {
  late MessageBloc sut;
  late FakeMessageService fakeMessageService;

  setUp(() {
    fakeMessageService = FakeMessageService();
    sut = MessageBloc(fakeMessageService);
  });

  tearDown(() => sut.close());

  test('should emit initial only without subscriptions', () {
    expect(sut.state, MessageInitialization());
  });
}