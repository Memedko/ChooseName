import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../data/repositories/name_repository.dart';
import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../data/services/analytics_service.dart';
import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_record.dart';

class MainSwipeViewModel extends ChangeNotifier {
  MainSwipeViewModel({
    required NameRepository nameRepository,
    required UserPreferencesRepository userPreferencesRepository,
    AnalyticsService? analyticsService,
  }) : _nameRepository = nameRepository,
       _userPreferencesRepository = userPreferencesRepository,
       _analyticsService = analyticsService ?? AnalyticsService.disabled(),
       _selectedGender = userPreferencesRepository.getSelectedGender();

  final NameRepository _nameRepository;
  final UserPreferencesRepository _userPreferencesRepository;
  final AnalyticsService _analyticsService;

  GenderType _selectedGender;
  bool _isLoading = false;
  String? _error;
  String _searchText = '';
  List<NameRecord> _names = const <NameRecord>[];
  StreamSubscription<List<NameRecord>>? _remoteNamesSubscription;

  GenderType get selectedGender => _selectedGender;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<NameRecord> get names => _names;
  int get shownCardsCount => _userPreferencesRepository.getShownCardsCount();

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _names = await _nameRepository.getNames(_selectedGender);
      _watchRemoteUpdates(_selectedGender);
    } on Object catch (error) {
      _error = error.toString();
      _names = const <NameRecord>[];
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
    await _analyticsService.logGenderSelected(gender);
    _searchText = '';
    await load();
  }

  Future<bool> like(NameRecord name) async {
    final nameId = name.nameId;
    if (nameId == null) {
      return false;
    }
    await _userPreferencesRepository.incrementShownCardsCount();
    await _nameRepository.likeName(_selectedGender, nameId);
    await _analyticsService.logNameLiked(name, _selectedGender);
    await load();
    return true;
  }

  Future<bool> dislike(NameRecord name) async {
    final nameId = name.nameId;
    if (nameId == null) {
      return false;
    }
    await _userPreferencesRepository.incrementShownCardsCount();
    await _nameRepository.dislikeName(_selectedGender, nameId);
    await _analyticsService.logNameDisliked(name, _selectedGender);
    await load();
    return true;
  }

  Future<void> resetDisliked() async {
    await _nameRepository.resetDisliked(_selectedGender);
    await _analyticsService.logResetDisliked(_selectedGender);
    await load();
  }

  Future<void> search(String text) async {
    _searchText = text.trim();
    if (_searchText.isEmpty) {
      await load();
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _analyticsService.logSearch(_selectedGender, _searchText);
      _names = await _nameRepository.search(_selectedGender, _searchText);
    } on Object catch (error) {
      _error = error.toString();
      _names = const <NameRecord>[];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _remoteNamesSubscription?.cancel();
    super.dispose();
  }

  void _watchRemoteUpdates(GenderType gender) {
    _remoteNamesSubscription?.cancel();
    _remoteNamesSubscription = _nameRepository
        .watchNames(gender)
        .listen(
          (names) async {
            if (_selectedGender != gender) {
              return;
            }
            if (_searchText.isEmpty) {
              _names = names;
            } else {
              _names = await _nameRepository.search(gender, _searchText);
            }
            notifyListeners();
          },
          onError: (Object error) {
            if (_selectedGender != gender) {
              return;
            }
            _error = error.toString();
            notifyListeners();
          },
        );
  }
}
