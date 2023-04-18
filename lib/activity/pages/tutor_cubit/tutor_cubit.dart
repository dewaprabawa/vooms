import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/activity/repository/tutor_repository.dart';

part 'tutor_state.dart';

class TutorCubit extends Cubit<TutorState> {
  TutorCubit(this._tutorRepository) : super(const TutorState());

  final TutorRepository _tutorRepository;

  Future<void> getTutors() async {
    emit(state.copyWith(tutorStateStatus: TutorStateStatus.loading));
    final data = await _tutorRepository.getTutors();
    if (data.isLeft()) {
      data.leftMap((error) => emit(state.copyWith(
          errorMessage: error.errorMessage,
          tutorStateStatus: TutorStateStatus.failure)));
      return;
    }
    data.map((entities) => emit(state.copyWith(
        entities: entities, tutorStateStatus: TutorStateStatus.loaded)));
  }
}
