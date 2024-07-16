import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCubit extends Cubit<List<User>> {

  GroupCubit() : super([]);

  addUser(User userToAdd) {
    state.add(userToAdd);
    emit(List.from(state));
  }

  remove(User userToRemove) {
    state.removeWhere((user) => user.id == userToRemove.id);
    emit(List.from(state));
  }
}