import '../../domain/models/gender_type.dart';
import '../../domain/models/name_decision.dart';
import '../../domain/models/name_record.dart';
import '../services/firestore_name_service.dart';
import '../services/local_name_database.dart';

class NameRepository {
  NameRepository({
    required LocalNameDatabase localDatabase,
    FirestoreNameService? remoteService,
  }) : _localDatabase = localDatabase,
       _remoteService = remoteService;

  final LocalNameDatabase _localDatabase;
  final FirestoreNameService? _remoteService;

  Future<List<NameRecord>> getNames(GenderType gender) async {
    final cached = await _localDatabase.getUnseenNames(gender);
    if (cached.isNotEmpty || _remoteService == null) {
      return cached;
    }
    final remoteNames = await _remoteService.fetchNames(gender);
    for (final remoteName in remoteNames) {
      await _localDatabase.upsertName(gender, remoteName.toDomain());
    }
    return _localDatabase.getUnseenNames(gender);
  }

  Stream<List<NameRecord>> watchNames(GenderType gender) async* {
    final remoteService = _remoteService;
    if (remoteService == null) {
      return;
    }
    await for (final remoteNames in remoteService.watchNames(gender)) {
      for (final remoteName in remoteNames) {
        await _localDatabase.upsertName(gender, remoteName.toDomain());
      }
      yield await _localDatabase.getUnseenNames(gender);
    }
  }

  Future<List<NameRecord>> search(GenderType gender, String text) {
    return _localDatabase.searchNames(gender, text);
  }

  Future<NameRecord?> findExact(GenderType gender, String text) {
    return _localDatabase.findNameByExactText(gender, text);
  }

  Future<List<NameRecord>> getFavorites(GenderType gender) {
    return _localDatabase.getLikedNames(gender);
  }

  Future<void> likeName(GenderType gender, String nameId) {
    return _localDatabase.setDecision(gender, nameId, NameDecision.liked);
  }

  Future<void> dislikeName(GenderType gender, String nameId) {
    return _localDatabase.setDecision(gender, nameId, NameDecision.disliked);
  }

  Future<void> unlikeName(GenderType gender, String nameId) {
    return _localDatabase.setDecision(gender, nameId, NameDecision.neutral);
  }

  Future<void> resetDisliked(GenderType gender) {
    return _localDatabase.resetDislikedNames(gender);
  }

  Future<void> chooseFavorite(GenderType gender, NameRecord name) async {
    final nameId = name.nameId;
    if (nameId == null) {
      return;
    }
    await _localDatabase.chooseFavorite(gender, nameId);
    await _remoteService?.saveFavoriteName(name.name, gender);
  }

  Future<void> addCustomFavorite(GenderType gender, String name) async {
    await _localDatabase.addCustomLikedName(gender, name);
    await _remoteService?.saveCustomName(name, gender);
  }

  Future<void> removeCustomName(GenderType gender, String name) {
    return _localDatabase.removeByName(gender, name);
  }

  Future<void> clearAll() {
    return _localDatabase.clearAll();
  }
}
