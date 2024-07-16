import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:mboa_connect/src/ui/pages/onboarding/onboarding_router_contract.dart';

class OnboardingRouter implements IOnboardingRouter {
  final Widget Function(User connectedUser) onSessionConnected;

  OnboardingRouter(this.onSessionConnected);

  @override
  void onSessionSuccess(BuildContext buildContext, User connectedUser) {
    Navigator.pushAndRemoveUntil(
        buildContext,
        MaterialPageRoute(builder: (_) => onSessionConnected(connectedUser)),
            (Route<dynamic> route) => false);
  }
}