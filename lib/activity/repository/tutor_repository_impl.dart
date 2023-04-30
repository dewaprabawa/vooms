import 'dart:developer';

import 'package:vooms/activity/repository/tutor_data_remote_impl.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:vooms/activity/repository/tutor_repository.dart';
import 'package:vooms/authentication/repository/failure.dart';

class TutorRepositoryImpl implements TutorRepository {
  final TutorDBservice _tutorDBService;

  TutorRepositoryImpl(this._tutorDBService);

  @override
  Future<Either<Failure, List<TutorEntity>>> getTutors() async {
    try {
      final tutorMaps = await _tutorDBService.retrieveList();
      log(tutorMaps.toString());
      final tutorEntities =
          tutorMaps.map((map) => TutorEntity.fromJson(map)).toList();
      return Right(tutorEntities);
    } on TutorDataException catch (e) {
      return Left(TutorDataError(errorMessage: e.toString()));
    } catch (e){
      return Left(TutorDataError(errorMessage: e.toString()));
    }
  }
  
 
}
