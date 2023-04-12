import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class AuthRepository {
  Future<void> signInUser({required String email, required String password});
  Future<bool> signUpUser();
  Future<bool> signOut();
}

class AuthRepositoryImpl extends AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<void> signInUser(
      {required String email, required String password}) async {
     try{
      await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
     } on FirebaseAuthException  catch (e) {
      e.code;
     }
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<bool> signUpUser() {
    // TODO: implement signUpUser
    throw UnimplementedError();
  }
}
