// onboarding_event.dart
part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class PageChangedEvent extends OnboardingEvent {
  const PageChangedEvent();
}

class PageSwipedEvent extends OnboardingEvent {
  final int index;

  const PageSwipedEvent({required this.index});

  @override
  List<Object> get props => [index];
}
