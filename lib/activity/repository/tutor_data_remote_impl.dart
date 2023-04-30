import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/authentication/repository/failure.dart';
import 'package:vooms/shareds/components/base_method.dart';
import 'package:vooms/shareds/general_helper/firebase_key_constant.dart';

abstract class TutorDBservice implements BaseMethod {
  
}


class TutorDataRemoteImpl implements TutorDBservice {
  late final CollectionReference _collectionUserReference;
  late final CollectionReference _collectionTutorReference;

  final FirebaseFirestore _firebaseFirestore;
  final AuthService _authService;
  TutorDataRemoteImpl(this._firebaseFirestore, this._authService) {
    _collectionTutorReference =
        _firebaseFirestore.collection(FirebaseKeyConstant.collectionTutorKey);
    _collectionUserReference =
        _firebaseFirestore.collection(FirebaseKeyConstant.collectionUserKey);
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> retrieve(String id) {
    // TODO: implement retrieve
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> retrieveList() async {
    try {
      final currentUser = await _authService.currentUser;

      // create a map of tutors indexed by their ID
      final tutorsQuerySnap = await _collectionTutorReference.get();
      final tutorsMap = {
        for (var tutorDoc in tutorsQuerySnap.docs)
          tutorDoc.id: tutorDoc.data() as Map<String, dynamic>,
      };

      // retrieve the user documents and merge with tutor details
      final usersQuerySnap = await _collectionUserReference.get();
      final usersList = [
        for (var userDoc in usersQuerySnap.docs)
          if (userDoc.id != currentUser?.uid &&
              tutorsMap.containsKey(userDoc.id))
            Map<String, dynamic>.from(userDoc.data() as Map<dynamic, dynamic>)
              ..['tutor_detail'] = tutorsMap[userDoc.id],
      ];

      return usersList;
    } catch (e) {
      throw TutorDataException();
    }
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
}
