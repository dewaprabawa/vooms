

import 'package:dartz/dartz.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/authentication/repository/failure.dart';

abstract class TutorRepository {
  Future<Either<Failure, List<TutorEntity>>> getTutors();
}


