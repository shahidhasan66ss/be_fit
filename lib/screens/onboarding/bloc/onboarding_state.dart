part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class PageChangedState extends OnboardingState {
  int counter;

  PageChangedState({
    this.counter=0,
  });
}

class NextScreenState extends OnboardingState {}