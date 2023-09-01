import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (_) => AuthRepository(FirebaseAuth.instance),
);

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  User? get authUser => _auth.currentUser;

  Future<UserCredential> signInWithAnonymously() => _auth.signInAnonymously();
}
