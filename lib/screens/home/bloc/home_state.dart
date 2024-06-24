part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class ProfileImageLoadedState extends HomeState {
  final String? imagePath;

  ProfileImageLoadedState({required this.imagePath});
}