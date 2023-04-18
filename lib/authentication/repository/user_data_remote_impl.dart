import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentication/repository/failure.dart';
import 'package:vooms/shareds/general_helper/firebase_key_constant.dart';


abstract class UserDBRemoteService {
  Future<void> save(Map<String,dynamic> map);
  Future<void> update(Map<String,dynamic> map);
  Future<void> delete(String id);
  Future<List<Map<String,dynamic>>> retrieveList();
  Future<Map<String,dynamic>> retrieve(String id);
}


class UserDataRemoteImpl implements UserDBRemoteService {
  late CollectionReference _collectionReference;

  final FirebaseFirestore _firebaseFirestore;

  UserDataRemoteImpl(this._firebaseFirestore) {
    _collectionReference = _firebaseFirestore.collection(FirebaseKeyConstant.collectionUserKey);
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _collectionReference.doc(id).delete();
    } catch (_) {
      throw UserStoreException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> retrieveList() async {
    return [];
  }

  @override
  Future<void> save(Map<String, dynamic> map) async {
    debugPrint(map.toString());
    try {
      await _collectionReference.doc(map["id"]).set(map);
    } catch (e) {
      debugPrint(e.toString() + "==USER==");
      throw UserStoreException();
    }
  }

  @override
  Future<void> update(Map<String, dynamic> map) async {
    try {
      await _collectionReference.doc(map["id"]).update(map);
    } catch (_) {
      throw UserStoreException();
    }
  }
   

  @override
  Future<Map<String, dynamic>> retrieve(String id) async {
    try {
      final querySnapshot = await _collectionReference.doc(id).get();
      final data = querySnapshot.data() as Map<String, dynamic>;
      return data;
    } catch (_) {
      throw UserStoreException();
    }
  }
}

mixin CheckMethod {
  Future<bool> checkDataExists(
      {required String fieldKey,
      required String valueToCheck,
      required String collectionKey}) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collectionKey)
          .where(fieldKey, isEqualTo: valueToCheck)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint(e.toString());
      throw UserStoreException();
    }
  }
}
