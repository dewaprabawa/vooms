import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentications/repository/db_service.dart';
import 'package:vooms/authentications/repository/failure.dart';

const String collectionAuthKey = "user_store";

class UserDataRemoteImpl implements DBservice {
  late CollectionReference _collectionReference;

  final FirebaseFirestore _firebaseFirestore;

  UserDataRemoteImpl(this._firebaseFirestore) {
    _collectionReference = _firebaseFirestore.collection(collectionAuthKey);
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
  Future<List<Map<String, dynamic>>> retrieveList(String key) async {
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
  Future<Map<String, dynamic>> retrieve() async {
    try {
      final querySnapshot = await _collectionReference.get();
      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
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
