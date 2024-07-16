import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';

abstract class IOnboardingRouter {
  void onSessionSuccess(BuildContext buildContext, User connectedUser);
}