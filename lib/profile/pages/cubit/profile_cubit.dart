import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vooms/authentications/repository/user_entity.dart';
import 'package:vooms/authentications/repository/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._userRepository) : super(const ProfileState());
  final UserRepository _userRepository;

  Future<void> getProfile() async {
    emit(state.copyWith(
        profileStatus: ProfileStatus.loading));
    final either = await _userRepository.getUser();
    either.fold((failure){
      emit(state.copyWith(errorMessage: failure.errorMessage));
    },(data){
      emit(state.copyWith(
        profileStatus: ProfileStatus.loaded,
         entity: data));
    });
  }
}
