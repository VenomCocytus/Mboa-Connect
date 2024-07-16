import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:mboa_connect/src/cache/local_cache_contract.dart';
import 'package:mboa_connect/src/states_management/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  IUserService _iUserService;
  ILocalCache _iLocalCache;

  HomeCubit(this._iUserService, this._iLocalCache) : super(HomeInitial());

  Future<User> login() async {

    final userJson = _iLocalCache.fetch('User');
    userJson['lastSeen'] = DateTime.now();
    userJson['active'] = true;

    final userToConnect = User.fromMap(userJson);
    await _iUserService.login(userToConnect);

    return userToConnect;
  }

  Future<void> logout(User userToLogout) async {

    emit(HomeLoading());

    final onlineUsers = await _iUserService.getOnlineUsers();
    onlineUsers.removeWhere((user) => user.id == userToLogout.id);

    emit(HomeSuccess(onlineUsers));
  }
}