import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_life/features/meditation_history/domain/entity/meditation_history.dart';
import 'package:meditation_life/features/meditation_history/domain/repository/meditation_history_repository.dart';
import 'package:meditation_life/features/meditation_history/infrastructure/dtos/meditation_history_dto.dart';

class FirebaseMeditationHistoryRepository
    implements MeditationHistoryRepository {
  FirebaseMeditationHistoryRepository(this._db);
  final FirebaseFirestore _db;

  static const _usersCollection = 'users';
  static const _meditationId = 'meditationId';
  static const _date = 'date';

  @override
  Future<void> add(String meditationId, DateTime date) async {
    final collectionName = _getCollectionName(date);
    final auth = FirebaseAuth.instance;
    await _db
        .collection(_usersCollection)
        .doc(auth.currentUser!.uid)
        .collection(collectionName)
        .add(
      <String, dynamic>{
        _meditationId: meditationId,
        _date: Timestamp.fromDate(date),
      },
    );
  }

  @override
  Future<List<MeditationHistory>> fetchAll(
    DateTime date,
  ) async {
    final collectionName = _getCollectionName(date);
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return [];
    }
    final snapshot = await _db
        .collection(_usersCollection)
        .doc(auth.currentUser!.uid)
        .collection(collectionName)
        .get();

    return snapshot.docs
        .map((doc) => MeditationHistoryDto.fromDocument(doc).toDomain())
        .toList();
  }

  // サブコレクションの名前を取得する
  String _getCollectionName(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    return 'meditationHistories_${year}_$month';
  }
}
