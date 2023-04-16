
import 'package:vooms/authentication/repository/user_model.dart';

abstract class AuthService {
  Stream<UserModel?> get onAuthStateChanged;
  Future<UserModel?> get currentUser;
  Future<UserModel?> signInAnonymously();
  Future<UserModel?> signInUser(String email, String password);
  Future<UserModel?> signUpUser(String email, String password);
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInWithFacebook();
  Future<void> resetPassword(String email);
  Future<void> signOut();
  void dispose();

  // Future<UserEntity> signInWithApple({List<Scope> scopes});
}