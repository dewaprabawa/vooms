part of 'theme_cubit.dart';

enum ThemeStatus { light, dark }

class ThemeState extends Equatable {
  final ThemeData? currentTheme;
  final ThemeStatus themeStatus;
  const ThemeState({this.currentTheme, this.themeStatus = ThemeStatus.light});

  ThemeState copyWith({ThemeData? currentTheme, ThemeStatus? themeStatus}) {
    return ThemeState(
        currentTheme: currentTheme ?? this.currentTheme,
        themeStatus: themeStatus ?? this.themeStatus);
  }

  @override
  List<Object?> get props => [currentTheme];
}
