import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:mboa_connect/src/cache/local_cache_contract.dart';
import 'package:mboa_connect/src/services/image_uploader.dart';
import 'package:mboa_connect/src/states_management/onboarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _iUserService;
  final ImageUploader _imageUploader;
  final ILocalCache _iLocalCache;

  OnboardingCubit(this._iUserService, this._imageUploader, this._iLocalCache)
      : super(OnboardingInitial());

  Future<void> signUp(String firstName, String lastName, File profilePicture) async {
    emit(Loading());

    final photoUrl = await _imageUploader.uploadImage(profilePicture);

    // Creating the user in the database
    final userToRegister = User(
        firstName: firstName,
        lastName: lastName,
        photoUrl: photoUrl,
        active: true,
        lastSeen: DateTime.now(),
    );

    final registeredUser = await _iUserService.login(userToRegister);

    final userCachedJson = {
      'firstName': registeredUser.firstName,
      'lastName': registeredUser.lastName,
      'active': true,
      'id': registeredUser.id,
    };

    await _iLocalCache.save("USER", userCachedJson);

    emit(OnboardingSuccess(registeredUser));
  }
}