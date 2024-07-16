import 'dart:async';

import 'package:chat/src/models/messages/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_service_contract.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class MessageService implements IMessageService {

  final Connection? _connection;
  final RethinkDb rethinkDb;
  final IEncryption? _encryption;

  final _controller = StreamController<Message>.broadcast();
  StreamSubscription? _changeFeed;

  MessageService(this.rethinkDb, this._connection, {IEncryption? encryption}) 
      : _encryption = encryption;

  @override
  dispose() {
    _changeFeed?.cancel();
    _controller.close();
  }

  @override
  Future<Message> sendMessages(List<Message> messages) async {
    final data = messages.map((message) {
        var data = message.toMap();
        if(_encryption != null) data['contents'] = _encryption.encrypt(message.contents);
        return data;
    }).toList();

    Map record = await (rethinkDb
        .table('messages')
        .insert(data, {'return_changes': true})
        .run(_connection!));

    return Message.fromMap(record['changes'].first['new_val']);
  }

  @override
  Stream<Message> getAllMessages({required User activeUser}) {
    _startReceivingMessages(activeUser);

    return _controller.stream;
  }

  _startReceivingMessages(User activeUser) {
    _changeFeed = rethinkDb
        .table('messages')
        .filter({'destination': activeUser.id})
        .changes({'include_initial': true})
        .run(_connection!)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((messageFeedData) {
            if(messageFeedData['new_val'] == null) return;
            
            final message = _getMessageFromFeed(messageFeedData);
            _controller.sink.add(message);
            _removeDeliveredMessage(message);
          })
          .catchError((err) => print(err))
              .onError((dynamic error, stackTrace) => print(error));
        });
  }

  Message _getMessageFromFeed(messageFeedData) {
    var data = messageFeedData['new_val'];
    if(_encryption != null) data['contents'] = _encryption.decrypt(data['contents']);

    return Message.fromMap(data);
  }

  _removeDeliveredMessage(Message messageToRemove) {
    rethinkDb
        .table('messages')
        .get(messageToRemove.id)
        .delete({'return_changes': false})
        .run(_connection!);
  }

}