import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {}

class OnboardingInitial extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Loading extends OnboardingState {
  @override
  List<Object> get props => [];
}

class OnboardingSuccess extends OnboardingState {
  final User connectedUser;

  OnboardingSuccess(this.connectedUser);

  @override
  List<Object> get props => [connectedUser];
}