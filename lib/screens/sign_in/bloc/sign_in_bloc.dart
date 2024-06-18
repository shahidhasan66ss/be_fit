import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../../core/service/auth_services.dart';
import '../../../core/service/validation_service.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<OnTextChangeEvent>(_onTextChangeEvent);
    on<SignInTappedEvent>(_onSignInTappedEvent);
    on<ForgotPasswordTappedEvent>(_onForgotPasswordTappedEvent);
    on<SignUpTappedEvent>(_onSignUpTappedEvent);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isButtonEnabled = false;

  void _onTextChangeEvent(OnTextChangeEvent event, Emitter<SignInState> emit) {
    final isEnabled = _checkIfSignInButtonEnabled();
    if (isButtonEnabled != isEnabled) {
      isButtonEnabled = isEnabled;
      emit(SignInButtonEnableChangedState(isEnabled: isButtonEnabled));
    }
  }

  Future<void> _onSignInTappedEvent(SignInTappedEvent event, Emitter<SignInState> emit) async {
    if (_checkValidatorsOfTextField()) {
      try {
        emit(LoadingState());
        await AuthService.signIn(emailController.text, passwordController.text);
        emit(NextTabBarPageState());
        print("Go to the next page");
      } catch (e) {
        print('E to tstrng: ' + e.toString());
        emit(ErrorState(message: e.toString()));
      }
    } else {
      emit(ShowErrorState());
    }
  }

  void _onForgotPasswordTappedEvent(ForgotPasswordTappedEvent event, Emitter<SignInState> emit) {
    emit(NextForgotPasswordPageState());
  }

  void _onSignUpTappedEvent(SignUpTappedEvent event, Emitter<SignInState> emit) {
    emit(NextSignUpPageState());
  }

  bool _checkIfSignInButtonEnabled() {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  bool _checkValidatorsOfTextField() {
    return ValidationService.email(emailController.text) && ValidationService.password(passwordController.text);
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
