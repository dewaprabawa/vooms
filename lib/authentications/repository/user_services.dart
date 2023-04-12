
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentications/repository/failure.dart';

abstract class DBservice<T> {
  Future<void> save(Map<String,dynamic> map);
  Future<void> update(Map<String,dynamic> map);
  Future<void> delete(String id);
  Future<T> retrieve(String key);
}


const String collectionAuthKey = "user_store";

class UserStoreImpl implements DBservice<List<Map<String, dynamic>>> {

  late CollectionReference collectionReference;

  final FirebaseFirestore _firebaseFirestore;

  UserStoreImpl(this._firebaseFirestore){
    collectionReference = _firebaseFirestore.collection(collectionAuthKey);
  }

  @override
  Future<void> delete(String id) async {
    try{
      await collectionReference.doc(id).delete();
    } catch(_) {
     throw AuthStoreException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> retrieve(String key) async {
    return [];
  }

  @override
  Future<void> save(Map<String, dynamic> map) async {
    debugPrint(map.toString());
    try{
      await collectionReference.add(map);
    } catch(e) {
      debugPrint(e.toString() + "==USER==");
     throw AuthStoreException();
    }
  }

  @override
  Future<void> update(Map<String, dynamic> map) async {
    try{
      await collectionReference.doc(map["id"]).update(map);
    } catch(_) {
     throw AuthStoreException();
    }
  }
}