import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/models/view/chats_view_model.dart';
import 'package:mboa_connect/src/states_management/group_message/group_message_bloc.dart';
import 'package:mboa_connect/src/states_management/home/chats_cubit.dart';
import 'package:mboa_connect/src/states_management/home/home_cubit.dart';
import 'package:mboa_connect/src/states_management/home/home_state.dart';
import 'package:mboa_connect/src/states_management/message/message_bloc.dart';
import 'package:mboa_connect/src/ui/pages/home/home_router.dart';
import 'package:mboa_connect/src/ui/widgets/shared/header_status.dart';
import 'package:mboa_connect/styles/colors.dart';

class Home extends StatefulWidget {

  final User loggedUser;
  final IHomeRouter iHomeRouter;
  final ChatsViewModel chatsViewModel;

  const Home({required this.loggedUser, required this.iHomeRouter, required this.chatsViewModel});

  @override
  _HomeState createdState() => _HomeState();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {

  User _loggedUser;
  List<User> _activeUsers = [];

  @override
  void initializeState() {
    super.initializeState();
    _loggedUser = widget.loggedUser;
    _setupConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: HeaderStatus(_user.username, _user.photoUrl, true),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Messages'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child:
                    BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
                      if (state is HomeSuccess) {
                        _activeUsers = state.onlineUsers;
                        return Text("Active(${state.onlineUsers.length})");
                      }

                      return Text("Active(0)");
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(_user, widget.router),
            ActiveUsers(widget.router, _user),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimary,
          child: Icon(
            Icons.group_add_rounded,
            color: Colors.white,
          ),
          onPressed: () async {
            await widget.iHomeRouter.onShowCreatedGroup(context, _activeUsers, _loggedUser);
          },
        ),
      ),
    );
  }

  @override
  bool get wantToKeepAlive => true;

  _setupConfiguration() async {

    final loggedUser = (!_loggedUser.active) ?
        await context.read<HomeCubit>().login() : _loggedUser;

    context.read<ChatsCubit>()..getChats();
    context.read<HomeCubit>().logout(loggedUser);
    context.read<MessageBloc>().add(MessageEvent.onSubscribe(loggedUser));
    context.read<GroupMessageBloc>().add(GroupMessageEvent.onSubscribe(loggedUser));
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();
}