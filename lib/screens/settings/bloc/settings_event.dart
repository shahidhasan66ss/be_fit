part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ToggleSetting extends SettingsEvent {
  final bool isEnabled;

  const ToggleSetting({required this.isEnabled});

  @override
  List<Object> get props => [isEnabled];
}

class LoadSettings extends SettingsEvent {}
