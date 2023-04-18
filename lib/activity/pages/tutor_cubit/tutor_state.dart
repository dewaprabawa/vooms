part of 'tutor_cubit.dart';

enum TutorStateStatus { initial, loaded, failure, loading }

class TutorState extends Equatable {
  const TutorState(
      {this.tutorStateStatus = TutorStateStatus.initial,
      this.entities = const [],
      this.errorMessage = ""});

  final TutorStateStatus tutorStateStatus;
  final List<TutorEntity> entities;
  final String errorMessage;

  TutorState copyWith(
      {TutorStateStatus? tutorStateStatus,
      List<TutorEntity>? entities,
      String? errorMessage}) {
    return TutorState(
        tutorStateStatus: tutorStateStatus ?? this.tutorStateStatus,
        entities: entities ?? this.entities,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [tutorStateStatus, entities, errorMessage];
}
