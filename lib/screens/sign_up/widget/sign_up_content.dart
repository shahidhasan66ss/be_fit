import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/const/color_constants.dart';
import '../../../core/const/text_constants.dart';
import '../../../core/service/validation_service.dart';
import '../../common_widgets/fitness_button.dart';
import '../../common_widgets/fitness_loading.dart';
import '../../common_widgets/fitness_text_field.dart';
import '../bloc/signup_bloc.dart';

class SignUpContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorConstants.white,
        child: Stack(
          children: [
            _createMainData(context),
            BlocBuilder<SignUpBloc, SignUpState>(
              buildWhen: (_, currState) => currState is LoadingState || currState is NextTabBarPageState || currState is ErrorState,
              builder: (context, state) {
                if (state is LoadingState) {
                  return _createLoading();
                } else if (state is NextTabBarPageState || state is ErrorState) {
                  return SizedBox();
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _createMainData(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _createTitle(),
            _createForm(context),
            const SizedBox(height: 40),
            _createSignUpButton(context),
            const SizedBox(height: 40),
            _createHaveAccountText(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _createLoading() {
    return FitnessLoading();
  }

  Widget _createTitle() {
    return Text(
      TextConstants.signUp,
      style: TextStyle(
        color: ColorConstants.textBlack,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    final bloc = BlocProvider.of<SignUpBloc>(context);
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (_, currState) => currState is ShowErrorState || currState is SignUpButtonEnableChangedState,
      builder: (context, state) {
        return Column(
          children: [
            FitnessTextField(
              title: TextConstants.username,
              placeholder: TextConstants.userNamePlaceholder,
              controller: bloc.userNameController,
              textInputAction: TextInputAction.next,
              errorText: TextConstants.usernameErrorText,
              isError: state is ShowErrorState ? !ValidationService.username(bloc.userNameController.text) : false,
              onTextChanged: () {
                print('Username text changed: ${bloc.userNameController.text}');
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            FitnessTextField(
              title: TextConstants.email,
              placeholder: TextConstants.emailPlaceholder,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: bloc.emailController,
              errorText: TextConstants.emailErrorText,
              isError: state is ShowErrorState ? !ValidationService.email(bloc.emailController.text) : false,
              onTextChanged: () {
                print('Email text changed: ${bloc.emailController.text}');
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            FitnessTextField(
              title: TextConstants.password,
              placeholder: TextConstants.passwordPlaceholder,
              obscureText: true,
              isError: state is ShowErrorState ? !ValidationService.password(bloc.passwordController.text) : false,
              textInputAction: TextInputAction.next,
              controller: bloc.passwordController,
              errorText: TextConstants.passwordErrorText,
              onTextChanged: () {
                print('Password text changed: ${bloc.passwordController.text}');
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            FitnessTextField(
              title: TextConstants.confirmPassword,
              placeholder: TextConstants.confirmPasswordPlaceholder,
              obscureText: true,
              isError: state is ShowErrorState ? !ValidationService.confirmPassword(bloc.passwordController.text, bloc.confirmPasswordController.text) : false,
              controller: bloc.confirmPasswordController,
              errorText: TextConstants.confirmPasswordErrorText,
              onTextChanged: () {
                print('Confirm password text changed: ${bloc.confirmPasswordController.text}');
                bloc.add(OnTextChangedEvent());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _createSignUpButton(BuildContext context) {
    final bloc = BlocProvider.of<SignUpBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (_, currState) => currState is SignUpButtonEnableChangedState,
        builder: (context, state) {
          print('SignUp button state: ${state is SignUpButtonEnableChangedState ? state.isEnabled : false}');
          return FitnessButton(
            title: TextConstants.signUp,
            isEnabled: state is SignUpButtonEnableChangedState ? state.isEnabled : false,
            onTap: () {
              FocusScope.of(context).unfocus();
              bloc.add(SignUpTappedEvent());
            },
          );
        },
      ),
    );
  }

  Widget _createHaveAccountText(BuildContext context) {
    final bloc = BlocProvider.of<SignUpBloc>(context);
    return RichText(
      text: TextSpan(
        text: TextConstants.alreadyHaveAccount,
        style: TextStyle(
          color: ColorConstants.textBlack,
          fontSize: 18,
        ),
        children: [
          TextSpan(
            text: " ${TextConstants.signIn}",
            style: TextStyle(
              color: ColorConstants.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                bloc.add(SignInTappedEvent());
              },
          ),
        ],
      ),
    );
  }
}
