import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/authentication/repository/failure.dart';
import 'package:vooms/authentication/repository/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthServicesImpl extends AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthServicesImpl(this._firebaseAuth, this._googleSignIn);

  @override
  void dispose() {}

  @override
  Future<UserModel?> signUpUser(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user?.toModel;
    } on FirebaseAuthException catch (exc) {
      debugPrint(exc.code + "===AUTH===");
      throw SignUpWithEmailAndPasswordException.fromCode(exc.code);
    }
  }

  @override
  Future<UserModel?> signInUser(String email, String password) async {
    debugPrint("$email $password");
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user?.toModel;
    } on FirebaseAuthException catch (exc) {
       log(exc.code); 
      throw SignInWithEmailAndPasswordException.fromCode(exc.code);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      throw SignOutException();
    }
  }

  @override
  Future<UserModel?> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final credential = await _firebaseAuth.signInWithCredential(authCredential);
      return credential.user?.toModel;
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleException.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleException();
    }
  }

  @override
  Stream<UserModel?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((user) {
       return user != null ? user.toModel : null;
    });
  }
  
  @override
  Future<UserModel?> get currentUser async => _firebaseAuth.currentUser?.toModel;
  
  @override
  Future<void> resetPassword(String email) async {
     try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
     } on FirebaseAuthException catch(_){
        throw const ResetPasswordException();
     }
  }
}
