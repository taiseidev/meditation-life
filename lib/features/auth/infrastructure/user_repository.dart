import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/features/auth/infrastructure/auth_repository.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    FirebaseFirestore.instance,
    ref.read(authRepositoryProvider),
  ),
);

class UserRepository {
  UserRepository(this._db, this._authRepository);
  final FirebaseFirestore _db;
  final AuthRepository _authRepository;

  static const _collection = 'users';
  static const _id = 'id';
  static const _createdAt = 'createdAt';

  Future<void> createUser() async {
    final auth = _authRepository.authUser;
    await _db.collection(_collection).doc(auth!.uid).set(
      <String, dynamic>{
        _id: auth.uid,
        _createdAt: Timestamp.now(),
      },
    );
  }
}
