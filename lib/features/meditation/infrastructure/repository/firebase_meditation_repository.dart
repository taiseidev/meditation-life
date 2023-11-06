import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_life/features/meditation/domain/meditation.dart';
import 'package:meditation_life/features/meditation/domain/repository/meditation_repository.dart';
import 'package:meditation_life/features/meditation/infrastructure/dtos/meditation_dto.dart';

class FirebaseMeditationRepository implements MeditationRepository {
  FirebaseMeditationRepository(this._db);
  final FirebaseFirestore _db;

  static const _collection = 'meditations';

  @override
  Stream<List<Meditation>> fetchMeditationsStream() {
    final snapshots = _db.collection(_collection).snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => MeditationDto.fromDocument(doc).toDomain(),
          )
          .toList(),
    );
  }

  @override
  Future<List<Meditation>> fetchMeditationsByIds(List<String> ids) async {
    // Firestoreのコレクションへの参照
    final collection = _db.collection(_collection);

    // 各IDに対して非同期的にドキュメントを取得するFutureのリストを作成
    final futures = ids.map((id) => collection.doc(id).get()).toList();

    // すべての非同期処理が完了するのを待つ
    final snapshots = await Future.wait(futures);

    // DocumentSnapshotからMeditationオブジェクトに変換
    return snapshots
        .where((snapshot) => snapshot.exists) // 存在するドキュメントのみをフィルタリング
        .map(
          (snapshot) => MeditationDto.fromDocument(snapshot).toDomain(),
        )
        .toList();
  }
}
