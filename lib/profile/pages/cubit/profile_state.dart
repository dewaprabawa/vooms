part of 'profile_cubit.dart';

enum ProfileStatus {initial, loaded, failure, loading}

 class ProfileState extends Equatable {

  const ProfileState({
    this.profileStatus = ProfileStatus.initial, 
     this.mesaage = "", 
     this.entity});

  final ProfileStatus profileStatus;
  final String mesaage;
  final UserEntity? entity;

  ProfileState copyWith({ProfileStatus? profileStatus, String? errorMessage, UserEntity? entity}){
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      mesaage: errorMessage ?? this.mesaage,
      entity: entity ?? this.entity
    );
  }

  @override
  List<Object?> get props => [profileStatus, mesaage, entity];
}


