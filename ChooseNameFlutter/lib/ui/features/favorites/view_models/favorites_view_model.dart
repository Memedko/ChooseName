import 'package:flutter/foundation.dart';

import '../../../../data/repositories/name_repository.dart';
import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../data/services/share_service.dart';
import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_decision.dart';
import '../../../../domain/models/name_record.dart';

enum AddFavoriteResult { added, alreadyLiked, alreadyDisliked }

enum ShareFavoritesResult { shared, copied }

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({
    required NameRepository nameRepository,
    required UserPreferencesRepository userPreferencesRepository,
    ShareService shareService = const ShareService(),
  }) : _nameRepository = nameRepository,
       _userPreferencesRepository = userPreferencesRepository,
       _shareService = shareService,
       _selectedGender = userPreferencesRepository.getSelectedGender();

  final NameRepository _nameRepository;
  final UserPreferencesRepository _userPreferencesRepository;
  final ShareService _shareService;

  GenderType _selectedGender;
  bool _isLoading = false;
  String? _error;
  List<NameRecord> _favorites = const <NameRecord>[];
  List<NameRecord> _searchResults = const <NameRecord>[];

  GenderType get selectedGender => _selectedGender;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<NameRecord> get favorites => _favorites;
  List<NameRecord> get searchResults => _searchResults;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _favorites = await _nameRepository.getFavorites(_selectedGender);
    } on Object catch (error) {
      _error = error.toString();
      _favorites = const <NameRecord>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectGender(GenderType gender) async {
    if (_selectedGender == gender) {
      return;
    }
    _selectedGender = gender;
    await _userPreferencesRepository.setSelectedGender(gender);
    _searchResults = const <NameRecord>[];
    await load();
  }

  Future<void> searchForAdding(String text) async {
    final query = text.trim();
    if (query.isEmpty) {
      _searchResults = const <NameRecord>[];
      notifyListeners();
      return;
    }
    _searchResults = await _nameRepository.search(_selectedGender, query);
    notifyListeners();
  }

  Future<AddFavoriteResult?> addName(String text) async {
    final query = text.trim();
    if (query.isEmpty) {
      return null;
    }
    final existing = await _nameRepository.findExact(_selectedGender, query);
    if (existing != null) {
      if (existing.decision == NameDecision.liked) {
        return AddFavoriteResult.alreadyLiked;
      }
      if (existing.decision == NameDecision.disliked) {
        return AddFavoriteResult.alreadyDisliked;
      }
      final nameId = existing.nameId;
      if (nameId != null) {
        await _nameRepository.likeName(_selectedGender, nameId);
      }
    } else {
      await _nameRepository.addCustomFavorite(_selectedGender, query);
    }
    _searchResults = const <NameRecord>[];
    await load();
    return AddFavoriteResult.added;
  }

  Future<void> remove(NameRecord name) async {
    final nameId = name.nameId;
    if (nameId == null || nameId.isEmpty) {
      await _nameRepository.removeCustomName(_selectedGender, name.name);
    } else {
      await _nameRepository.unlikeName(_selectedGender, nameId);
    }
    await load();
  }

  Future<void> choose(NameRecord name) async {
    await _nameRepository.chooseFavorite(_selectedGender, name);
    await load();
  }

  Future<ShareFavoritesResult> shareFavorites() async {
    final result = await _shareService.shareText(
      buildShareText(),
      subject: 'Імʼя малюка',
    );
    return switch (result) {
      ShareResult.shared => ShareFavoritesResult.shared,
      ShareResult.copied => ShareFavoritesResult.copied,
    };
  }

  String buildShareText() {
    final buffer = StringBuffer('Мені подобаються такі імена:\n\n');
    for (final name in _favorites) {
      buffer.writeln('${name.isChosenFavorite ? '❤️' : '👶🏻'} ${name.name}');
    }
    buffer.write(
      '\nОтримайте більше інформації про імена в додатку "Імʼя малюка" '
      '(https://apps.apple.com/ua/app/id1553686058).',
    );
    return buffer.toString();
  }
}
