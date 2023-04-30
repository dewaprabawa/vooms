import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/authentication/repository/failure.dart';
import 'package:vooms/shareds/components/base_method.dart';
import 'package:vooms/shareds/general_helper/firebase_key_constant.dart';

abstract class CourseDataRemote implements BaseMethod {}

class CourseDataRemoteImpl implements CourseDataRemote {
  late final CollectionReference _collectionCourseReference;
  late final CollectionReference _collectionUserReference;
  late final CollectionReference _collectionTutorReference;

  final FirebaseFirestore _firebaseFirestore;
  final AuthService _authService;
  CourseDataRemoteImpl(this._firebaseFirestore, this._authService) {
    _collectionTutorReference =
        _firebaseFirestore.collection(FirebaseKeyConstant.collectionTutorKey);
    _collectionUserReference =
        _firebaseFirestore.collection(FirebaseKeyConstant.collectionUserKey);
    _collectionCourseReference =
        _firebaseFirestore.collection(FirebaseKeyConstant.collectionCourseKey);
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> save(Map<String, dynamic> map) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> update(Map<String, dynamic> map) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> retrieve(String id) async {
     try{
      final data = await _collectionCourseReference.doc(id).get();
      return data.data() as Map<String,dynamic>;
     }catch(_){
      throw CourseDataException();
     }
  }

  @override
  Future<List<Map<String, dynamic>>> retrieveList() {
    // TODO: implement retrieveList
    throw UnimplementedError();
  }
}
