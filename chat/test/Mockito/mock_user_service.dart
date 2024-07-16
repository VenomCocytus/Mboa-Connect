import 'package:chat/src/models/user.dart';
import 'package:mockito/mockito.dart';
import 'package:chat/src/services/user/user_service_contract.dart';

class MockUserService extends Mock implements IUserService {
  @override
  Future<List<User>> getAllUsers(List<String?>? userIds) async {
    return super.noSuchMethod(Invocation.method(#getAllUsers, [userIds]),
        returnValue: Future<List<User>>.value([]));
  }

  @override
  Future<List<User>> getOnlineUsers() async {
    // TODO: implement getOnlineUsers
    throw UnimplementedError();
  }

  @override
  Future<User> login(User user) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout(User user) {
    // TODO: implement logout
    throw UnimplementedError();
  }
}