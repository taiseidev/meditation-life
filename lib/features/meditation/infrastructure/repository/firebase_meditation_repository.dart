import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/dtos/meditation_dto.dart';

class FirebaseMeditationRepository implements MeditationRepository {
  final FirebaseFirestore _db;

  FirebaseMeditationRepository(this._db);

  static const _collection = "meditations";
  static const _usersCollection = "users";
  static const _meditationId = "meditationId";
  static const _date = "date";

  @override
  Future<void> addMeditation(String meditationId) async {
    // TODO: FirebaseAuth周りを修正する
    final auth = FirebaseAuth.instance;
    await _db
        .collection(_usersCollection)
        .doc(auth.currentUser!.uid)
        .collection(_collection)
        .add(
      <String, dynamic>{
        _meditationId: meditationId,
        _date: DateTime.now(),
      },
    );
  }

  @override
  Stream<List<Meditation>> fetchMeditationsStream() {
    return _db.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MeditationDto.fromDocument(doc).toDomain(),
              )
              .toList(),
        );
  }
}
