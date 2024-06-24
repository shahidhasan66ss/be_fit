part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool isEnabled;

  const SettingsLoaded({required this.isEnabled});

  @override
  List<Object> get props => [isEnabled];
}

class ProfileImageLoaded extends SettingsState {
  final String? imagePath;

  const ProfileImageLoaded({this.imagePath});

  @override
  List<Object> get props => [];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object> get props => [message];
}