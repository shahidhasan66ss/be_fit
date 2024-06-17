import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../core/service/auth_services.dart';
import '../../../core/service/validation_service.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignupEvent, SignUpState> {
  SignUpBloc() : super(SignupInitial()) {
    on<OnTextChangedEvent>(_onTextChangedEvent);
    on<SignUpTappedEvent>(_onSignUpTappedEvent);
    on<SignInTappedEvent>(_onSignInTappedEvent);
  }

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  Stream<SignUpState> mapEventToState(SignupEvent event) async* {
    if (event is OnTextChangedEvent) {
      if (isButtonEnabled != checkIfSignUpButtonEnabled()) {
        isButtonEnabled = checkIfSignUpButtonEnabled();
        yield SignUpButtonEnableChangedState(isEnabled: isButtonEnabled);
      }
    } else if (event is SignUpTappedEvent) {
      if (checkValidatorsOfTextField()) {
        try {
          yield LoadingState();
          await AuthService.signUp(
            emailController.text,
            passwordController.text,
            userNameController.text,
          );
          yield NextTabBarPageState();
          print("Go to the next page");
        } catch (e) {
          yield ErrorState(message: e.toString());
        }
      } else {
        yield ShowErrorState();
      }
    } else if (event is SignInTappedEvent) {
      yield NextSignInPageState();
    }
  }

  void _onTextChangedEvent(OnTextChangedEvent event, Emitter<SignUpState> emit) {
    if (isButtonEnabled != checkIfSignUpButtonEnabled()) {
      isButtonEnabled = checkIfSignUpButtonEnabled();
      emit(SignUpButtonEnableChangedState(isEnabled: isButtonEnabled));
    }
  }

  void _onSignUpTappedEvent(SignUpTappedEvent event, Emitter<SignUpState> emit) async {
    if (checkValidatorsOfTextField()) {
      try {
        emit(LoadingState());
        await AuthService.signUp(
          emailController.text,
          passwordController.text,
          userNameController.text,
        );
        emit(NextTabBarPageState());
        print("Go to the next page");
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    } else {
      emit(ShowErrorState());
    }
  }

  void _onSignInTappedEvent(SignInTappedEvent event, Emitter<SignUpState> emit) {
    emit(NextSignInPageState());
  }

  bool checkIfSignUpButtonEnabled() {
    return userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool checkValidatorsOfTextField() {
    return ValidationService.username(userNameController.text) &&
        ValidationService.email(emailController.text) &&
        ValidationService.password(passwordController.text) &&
        ValidationService.confirmPassword(
            passwordController.text, confirmPasswordController.text);
  }
}
