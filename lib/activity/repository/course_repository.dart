import 'package:dartz/dartz.dart';
import 'package:vooms/authentication/repository/failure.dart';
import 'package:vooms/shareds/components/base_method.dart';

abstract class CourseRepository{
  Future<Either<Failure, Unit>> registerCourse(String courseId);
}
