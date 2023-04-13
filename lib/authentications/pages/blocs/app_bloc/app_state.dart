part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
  
  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class AppAuthenticated extends AppState {}

class AppUnauthenticaed extends AppState {}