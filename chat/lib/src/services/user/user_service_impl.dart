import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class UserService implements IUserService {
  final Connection? _connection;
  final RethinkDb rethinkDb;

  UserService(this.rethinkDb, this._connection);

  /*Login to the chat app*/
  @override
  Future<User> login(User user) async {
    var data =  user.toMap();

    // Checking if the user has a non-null id property.
    if(user.id != null) data['id'] = user.id;

    // Checking if the user has a non-null username property.
    if(user.username != null) data['username'] = user.username;

    final result = await rethinkDb
        .table('users')
        .insert(data, {
          'conflict': 'update',
          'return_changes': true,
        }).run(_connection!);

    // Retrieving the changed data from the result and creating a new user object from it.
    return User.fromMap(result['changes'].first['new_val']);
  }

  @override
  Future<void> logout(User user) async {
    await rethinkDb
        .table('users')
        .update({
          'id': user.id,
          'active': false,
          'lastSeen': DateTime.now()
        })
        .run(_connection!);

    // disconnection
    _connection.close();
  }

  /*Get all the online users*/
  @override
  Future<List<User>> getOnlineUsers() async {
    Cursor usersCursor = await (rethinkDb
        .table('users')
        .filter({'active': true})
        .run(_connection!));
    final usersList = await usersCursor.toList();

    return usersList
        .map((user) =>
          User.fromMap(user))
        .toList();
  }

  @override
  Future<List<User>> getAllUsers(List<String?> userIds) async {
    Cursor usersCursor = await rethinkDb
        .table('users')
        .getAll(rethinkDb.args(userIds))
        .filter({'active': true})
        .run(_connection);
    List usersList = await usersCursor.toList();

    return usersList
        .map((user) =>
        User.fromMap(user))
        .toList();
  }
  
}