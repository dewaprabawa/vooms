part of 'app_state_cubit.dart';

enum AppStateStatus { initial, authenticated, notAuthenticated, failure}

class AppStateState extends Equatable {
  const AppStateState._({this.appStateStatus = AppStateStatus.initial, this.appRoute = ""});

  final AppStateStatus appStateStatus;
  final String appRoute; 

  const AppStateState.initial():this._(appStateStatus: AppStateStatus.initial);

  const AppStateState.authenticated():this._(appStateStatus: AppStateStatus.authenticated);

  const AppStateState.notAuthenticated():this._(appStateStatus: AppStateStatus.notAuthenticated);

  const AppStateState.failure():this._(appStateStatus: AppStateStatus.failure);

  AppStateState copyWith(String? appRoute){
    return AppStateState._(appRoute: appRoute ?? this.appRoute);
  }

  @override
  List<Object> get props => [appStateStatus, appRoute];
}

