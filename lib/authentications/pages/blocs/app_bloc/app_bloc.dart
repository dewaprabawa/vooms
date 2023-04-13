import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vooms/authentications/repository/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._authRepository) : super(AppInitial()) {
    on<AppEvent>((event, emit) {
        on<AppSignOutEvent>(_onSignOutEvent);
      _appStateSubscription = _authRepository.listenToUserChanges().listen(
      (isAuthenticated){
        if(isAuthenticated){
          emit(AppAuthenticated());
        }else{
          emit(AppAuthenticated());
        }
      },
    );
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<bool> _appStateSubscription;
  
  void _onSignOutEvent(AppSignOutEvent event, Emitter<AppState> emit) {
    unawaited(_authRepository.signOutUser());
  }

 @override
  Future<void> close() {
    _appStateSubscription.cancel();
    return super.close();
  }
}
