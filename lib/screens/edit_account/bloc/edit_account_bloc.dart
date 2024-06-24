import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/service/firebase_storage_service.dart';
import '../../../core/service/user_service.dart';

part 'edit_account_event.dart';
part 'edit_account_state.dart';

class EditAccountBloc extends Bloc<EditAccountEvent, EditAccountState> {
  static const String _profileImageKey = 'profile_image_path';

  EditAccountBloc() : super(EditAccountInitial()) {
    on<UploadImage>(_onUploadImage);
    on<ChangeUserData>(_onChangeUserData);
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_profileImageKey);
    if (imagePath != null && imagePath.isNotEmpty) {
      emit(EditPhotoSuccess(XFile(imagePath)));
    } else {
      // Emit a default state with a default image (you can replace it with an asset path if needed)
      emit(EditAccountInitial());
    }
  }

  Future<void> _onUploadImage(UploadImage event, Emitter<EditAccountState> emit) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        emit(EditAccountProgress());

        await FirebaseStorageService.uploadImage(filePath: image.path);
        await _saveProfileImage(image.path);
        emit(EditPhotoSuccess(image));
      }
    } catch (e) {
      emit(EditAccountError(e.toString()));
      await Future.delayed(Duration(seconds: 1));
      emit(EditAccountInitial());
    }
  }

  Future<void> _saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, path);
  }

  Future<void> _onChangeUserData(ChangeUserData event, Emitter<EditAccountState> emit) async {
    emit(EditAccountProgress());
    try {
      await UserService.changeUserData(displayName: event.displayName, email: event.email);
      emit(EditAccountInitial());
    } catch (e) {
      emit(EditAccountError(e.toString()));
      await Future.delayed(Duration(seconds: 1));
      emit(EditAccountInitial());
    }
  }
}
