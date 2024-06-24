import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const String _profileImageKey = 'profile_image_path';

  HomeBloc() : super(HomeInitial()) {
    on<LoadProfileImageEvent>(_onLoadProfileImage);
    on<ReloadImageEvent>(_onReloadImage);
  }

  Future<void> _onLoadProfileImage(LoadProfileImageEvent event, Emitter<HomeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_profileImageKey);
    emit(ProfileImageLoadedState(imagePath: imagePath));
  }

  Future<void> _onReloadImage(ReloadImageEvent event, Emitter<HomeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_profileImageKey);
    emit(ProfileImageLoadedState(imagePath: imagePath));
  }
}
