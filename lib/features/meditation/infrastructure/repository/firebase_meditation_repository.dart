import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/dtos/meditation_dto.dart';

class FirebaseMeditationRepository implements MeditationRepository {
  final FirebaseFirestore _firestore;

  FirebaseMeditationRepository(this._firestore);

  static const _collection = "meditations";

  @override
  Stream<List<Meditation>> fetchMeditationsStream() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MeditationDto.fromDocument(doc).toDomain(),
              )
              .toList(),
        );
  }
}
