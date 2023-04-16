import 'dart:io'; // Import the dart:io library for file operations

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vooms/authentication/repository/user_entity.dart';
import 'package:vooms/authentication/repository/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userRepository) : super(const ProfileState());

  final UserRepository
      _userRepository; // Define a final variable to hold the user repository

  // Define a function to get the user profile information
  Future<void> getProfile() async {
    emit(state.copyWith(
        userStateStatus:
            UserStateStatus.loading)); // Update the state with loading status
    final either = await _userRepository
        .getUser(); // Call the getUser function from the user repository
    either.fold((failure) {
      emit(state.copyWith(
          errorMessage: failure
              .errorMessage)); // Update the state with error message if there's a failure
    }, (data) {
      emit(state.copyWith(
          userStateStatus: UserStateStatus.loaded,
          entity:
              data)); // Update the state with the loaded user profile information
    });
  }

  // Define a function to update the user image
  Future<void> updateImage(File file) async {
    emit(state.copyWith(userStateStatus: UserStateStatus.loading));
    // Update the state with initial image state status

    // Call the uploadImageUser function from the user repository and wait for the result
    final uploadResult = await _userRepository.uploadImageUser(file);

    if (uploadResult.isLeft()) {
      uploadResult
          .leftMap((l) => emit(state.copyWith(errorMessage: l.errorMessage)));
      // Update the state with error message if there's a failure
      return;
    }

    // Call the getUser function from the user repository and wait for the result
    final getUserResult = await _userRepository.getUser();

    if (getUserResult.isLeft()) {
      uploadResult
          .leftMap((l) => emit(state.copyWith(errorMessage: l.errorMessage)));
      // Update the state with error message if there's a failure
      return;
    }

    emit(state.copyWith(
      userStateStatus: UserStateStatus.imageUploaded,
    ));
    // Update the state with the loaded user profile information, including the new user image
    getUserResult.map((entity) => emit(
          state.copyWith(
            userStateStatus: UserStateStatus.loaded,
            entity: entity,
          ),
        ));
  }
}
