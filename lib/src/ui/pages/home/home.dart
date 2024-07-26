import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/models/view/chats_view_model.dart';
import 'package:mboa_connect/src/states_management/group_message/group_message_bloc.dart';
import 'package:mboa_connect/src/states_management/home/chats_cubit.dart';
import 'package:mboa_connect/src/states_management/home/home_cubit.dart';
import 'package:mboa_connect/src/states_management/home/home_state.dart';
import 'package:mboa_connect/src/states_management/message/message_bloc.dart';
import 'package:mboa_connect/src/ui/pages/home/home_router.dart';
import 'package:mboa_connect/src/ui/widgets/home/active/active_users.dart';
import 'package:mboa_connect/src/ui/widgets/home/chats/chats_widget.dart';
import 'package:mboa_connect/src/ui/widgets/shared/header_status.dart';
import 'package:mboa_connect/styles/colors.dart';

class Home extends StatefulWidget {

  final User loggedUser;
  final IHomeRouter iHomeRouter;
  final ChatsViewModel chatsViewModel;

  const Home({required this.loggedUser, required this.iHomeRouter, required this.chatsViewModel});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {

  late User _loggedUser;
  List<User> _activeUsers = [];

  @override
  void initState() {
    super.initState();
    _loggedUser = widget.loggedUser;
    _setupConfiguration();
  }

  _setupConfiguration() async {

    final loggedUser = (!_loggedUser.active!) ?
        await context.read<HomeCubit>().login() : _loggedUser;

    context.read<ChatsCubit>()..getChats();
    context.read<HomeCubit>().logout(loggedUser);
    context.read<MessageBloc>().add(MessageEvent.onSubscribe(loggedUser));
    context.read<GroupMessageBloc>().add(GroupMessageEvent.onSubscribe(loggedUser));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: HeaderStatus(_loggedUser.username ?? '', _loggedUser.photoUrl ?? '', true),
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
            ChatsWidget(_loggedUser, widget.iHomeRouter),
            ActiveUsers(widget.iHomeRouter, _loggedUser),
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
  bool get wantKeepAlive => true;
}