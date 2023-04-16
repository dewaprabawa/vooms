part of 'profile_cubit.dart';

enum UserStateStatus {initial, loaded, failure, loading, imageUploaded}


 class ProfileState extends Equatable {

  const ProfileState({
    this.userStateStatus = UserStateStatus.initial, 
     this.mesaage = "", 
     this.entity});

  final UserStateStatus userStateStatus;
  final String mesaage;
  final UserEntity? entity;

  ProfileState copyWith({
    UserStateStatus? userStateStatus,
     String? errorMessage, 
     UserEntity? entity,
     }){
    return ProfileState(
      userStateStatus: userStateStatus ?? this.userStateStatus,
      mesaage: errorMessage ?? this.mesaage,
      entity: entity ?? this.entity
    );
  }

  @override
  List<Object?> get props => [userStateStatus, mesaage, entity];
}


