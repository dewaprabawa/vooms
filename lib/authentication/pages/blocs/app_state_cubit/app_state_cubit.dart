import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vooms/authentication/repository/auth_repository.dart';

part 'app_state_state.dart';

class AppStateCubit extends Cubit<AppStateState> {
  AppStateCubit(this._authRepository) : super(const AppStateState.initial());
  final AuthRepository _authRepository;

  void startListentStateChanges(bool isAuthenticated){
        if(isAuthenticated){
            emit(const AppStateState.authenticated());
        }else{
            emit(const AppStateState.notAuthenticated());
        }
  }

  Future<void> signOut() async{
    await _authRepository.signOutUser().then((either){
        either.fold((error){
          emit(const AppStateState.failure());
        }, (success){
          emit(const AppStateState.notAuthenticated());
        });
    });
  }

}
