// onboarding_state.dart
part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class PageChangedState extends OnboardingState {
  final int counter;

  const PageChangedState({required this.counter});

  @override
  List<Object> get props => [counter];
}

class NextScreenState extends OnboardingState {}
