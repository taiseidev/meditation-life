import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepository(FirebaseAuth.instance);

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  User? get authUser => _auth.currentUser;

  Future<UserCredential> signInWithAnonymously() => _auth.signInAnonymously();
}
