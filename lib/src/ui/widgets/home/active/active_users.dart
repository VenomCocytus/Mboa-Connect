import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/common/define/chat_type.dart';
import 'package:mboa_connect/src/models/data/chat.dart';
import 'package:mboa_connect/src/states_management/home/home_cubit.dart';
import 'package:mboa_connect/src/states_management/home/home_state.dart';
import 'package:mboa_connect/src/ui/pages/home/home_router.dart';
import 'package:mboa_connect/src/ui/widgets/common/profile_image.dart';

class ActiveUsers extends StatefulWidget {

  final User loggedUser;
  final IHomeRouter iHomeRouter;

  ActiveUsers(this.iHomeRouter, this.loggedUser);

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (_, homeState) {
      
      if(homeState is HomeLoading) return Center(child: CircularProgressIndicator());
      if(homeState is HomeSuccess) _buildList(homeState.onlineUsers);
      
      return Container();
    });
  }

  _buildList(List<User> users) => ListView.separated(
      padding: EdgeInsets.only(top: 30, right: 16),
      itemBuilder: (BuildContext context, index) => GestureDetector(
        child: _listItem(users[index]),
        onTap: () => this.widget.iHomeRouter.onShowMessageThread(
            context,
            [users[index]],
            widget.loggedUser,
            Chat(users[index].id ?? '', ChatType.individual)),
      ),
      separatorBuilder: (_, __) => Divider(),
      itemCount: users.length);

  _listItem(User loggedUser) => ListTile(
    leading: ProfilePicture(
      photoUrl: loggedUser.photoUrl ?? '',
      online: true,
    ),
    title: Text(
      loggedUser.username ?? '',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}