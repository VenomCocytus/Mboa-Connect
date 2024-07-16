import 'dart:async';

import 'package:chat/src/models/messages/group_message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/group/group_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class GroupMessageService implements IGroupService {
  final Connection _connection;
  final RethinkDb rethinkDb;

  final _controller = StreamController<GroupMessage>.broadcast();
  StreamSubscription? _changeFeed;

  GroupMessageService(this.rethinkDb, this._connection);

  @override
  Future<GroupMessage> sendGroupMessage(GroupMessage groupMessage) async {
    Map record = await (
        rethinkDb
            .table('message_groups')
            .insert(
            groupMessage.toMap(),
            {'return_changes': true})
            .run(_connection)
        as FutureOr<Map<dynamic, dynamic>>);

    return GroupMessage.fromMap(record['changes'].first['new_val']);
  }

  @override
  dispose() {
    _changeFeed?.cancel();
    _controller.close();
  }

  @override
  Stream<GroupMessage> getGroupMessages({required User? loggedUser}) {
    _startReceivingGroupMessage(loggedUser);

    return _controller.stream;
  }

  _startReceivingGroupMessage(User? loggedUser) {
    _changeFeed = rethinkDb
        .table('group_messages')
        .filter(
            (groupMessage) =>
            groupMessage('members')
                .contains(loggedUser!.id)
                .and(
                groupMessage('createBy')
                    .ne(loggedUser.id))
                .and(
                groupMessage
                    .hasFields('receivedBy')
                    .not()
                    .or(groupMessage('receivedBy').contains(loggedUser).not())
            )
    )
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
      event
          .forEach((groupMessageFeedData) {
        if (groupMessageFeedData['new_val'] == null) return;

        final groupMessage = _getGroupMessageFromFeed(groupMessageFeedData);
        _controller.sink.add(groupMessage);
        _updateWhenReceivingSentGroupMessage(groupMessage, loggedUser);
      })
          .catchError((err) => print(err))
          .onError((dynamic error, stackTrace) => print(error));
    });
  }

  GroupMessage _getGroupMessageFromFeed(groupMessageFeedData) {
    var groupMessageData = groupMessageFeedData['new_val'];

    return GroupMessage.fromMap(groupMessageData);
  }

  _updateWhenReceivingSentGroupMessage(GroupMessage groupMessage,
      User? loggedUser) async {
    Map updatedGroupMessage = await (
        rethinkDb
            .table('group_messages')
            .get(groupMessage.id)
            .update(
                (groupMessage) =>
                rethinkDb
                    .branch(groupMessage.hasFields('receivedBy'), {
                  'receivedBy': groupMessage('receivedBy').append(
                      loggedUser!.id)
                }, {
                  'receivedBy': [loggedUser.id]
                }),
            {'return_changes': 'always'})
            .run(_connection)
    );

    _removeGroupMessageWhenDeliveredToAllDestinations(
        updatedGroupMessage['changes'][0]);
  }

  _removeGroupMessageWhenDeliveredToAllDestinations(Map map) {
    final List allMembers = map['new_val']['members'];
    final List alreadyReceivedMembers = map['new_val']['receivedBy'];
    final String? id = map['new_val']['id'];

    if(allMembers.length > alreadyReceivedMembers.length) return;

    rethinkDb
        .table('group_messages')
        .get(id)
        .delete({'return_changes': false})
        .run(_connection);

  }

}
