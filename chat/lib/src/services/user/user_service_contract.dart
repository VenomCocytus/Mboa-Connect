import '../../models/user.dart';

abstract class IUserService{
  Future<User> login(User user);
  Future<void> logout(User user);
  Future<List<User>> getOnlineUsers();
  Future<List<User>> getAllUsers(List<String?> userIds);
}