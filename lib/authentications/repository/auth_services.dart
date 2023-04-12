import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentications/repository/failure.dart';
import 'package:vooms/authentications/repository/user_model.dart';

abstract class AuthService {
  Stream<UserModel?> get onAuthStateChanged;
  Future<UserModel> signInAnonymously();
  Future<UserModel?> signInUser(
      String email, String password);
  Future<UserModel?> signUpUser(
      String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
  Future<void> signOut();
  void dispose();

  // Future<UserEntity> signInWithApple({List<Scope> scopes});
}

class AuthServicesImpl extends AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthServicesImpl(this._firebaseAuth);


  @override
  void dispose() {
    
  }


  @override
  Future<UserModel?> signUpUser(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
        return Mapper.toModel(credential.user!);
    } on FirebaseAuthException catch (exc) {
      debugPrint(exc.code + "===AUTH===");
      throw SignUpWithEmailAndPasswordException.fromCode(exc.code);
    }
  }

  @override
  Future<UserModel?> signInUser(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Mapper.toModel(credential.user!);
    } on FirebaseAuthException catch (exc) {
      throw SignInWithEmailAndPasswordException.fromCode(exc.code);
    }
  }


  @override
  Future<void> signOut() async {
    try{
      await _firebaseAuth.signOut();
    }catch(_){
      throw SignOutException();
    }
  }


  @override
  Future<UserModel> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }
  
  @override
  Stream<UserModel> get onAuthStateChanged{
     return _firebaseAuth.authStateChanges().map((user) {
      return Mapper.toModel(user!);
    });
  }
}
