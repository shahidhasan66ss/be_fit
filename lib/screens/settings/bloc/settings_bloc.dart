import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<ToggleSetting>(_onToggleSetting);
    on<LoadSettings>(_onLoadSettings);
  }

  Future<void> _onToggleSetting(ToggleSetting event, Emitter<SettingsState> emit) async {
    try {
      // Simulating a save operation
      await Future.delayed(Duration(milliseconds: 500));
      emit(SettingsLoaded(isEnabled: event.isEnabled));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    try {
      // Simulating a load operation
      await Future.delayed(Duration(milliseconds: 500));
      emit(SettingsLoaded(isEnabled: true)); // Default value for demonstration
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}
