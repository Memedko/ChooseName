import 'celebrity.dart';
import 'character.dart';
import 'child.dart';
import 'name_decision.dart';
import 'song.dart';

class NameRecord {
  const NameRecord({
    this.nameId,
    this.name = '',
    this.versions,
    this.days,
    this.description,
    this.nameEng,
    this.nameRu,
    this.transliteration,
    this.celebrities = const <Celebrity>[],
    this.songs = const <Song>[],
    this.characters = const <Character>[],
    this.children = const <Child>[],
    this.decision = NameDecision.neutral,
    this.isChosenFavorite = false,
    this.sameNames,
    this.langs,
  });

  final String? nameId;
  final String name;
  final String? versions;
  final String? days;
  final String? description;
  final String? nameEng;
  final String? nameRu;
  final String? transliteration;
  final List<Celebrity> celebrities;
  final List<Song> songs;
  final List<Character> characters;
  final List<Child> children;
  final NameDecision decision;
  final bool isChosenFavorite;
  final String? sameNames;
  final String? langs;

  NameRecord copyWith({
    String? nameId,
    String? name,
    String? versions,
    String? days,
    String? description,
    String? nameEng,
    String? nameRu,
    String? transliteration,
    List<Celebrity>? celebrities,
    List<Song>? songs,
    List<Character>? characters,
    List<Child>? children,
    NameDecision? decision,
    bool? isChosenFavorite,
    String? sameNames,
    String? langs,
  }) {
    return NameRecord(
      nameId: nameId ?? this.nameId,
      name: name ?? this.name,
      versions: versions ?? this.versions,
      days: days ?? this.days,
      description: description ?? this.description,
      nameEng: nameEng ?? this.nameEng,
      nameRu: nameRu ?? this.nameRu,
      transliteration: transliteration ?? this.transliteration,
      celebrities: celebrities ?? this.celebrities,
      songs: songs ?? this.songs,
      characters: characters ?? this.characters,
      children: children ?? this.children,
      decision: decision ?? this.decision,
      isChosenFavorite: isChosenFavorite ?? this.isChosenFavorite,
      sameNames: sameNames ?? this.sameNames,
      langs: langs ?? this.langs,
    );
  }
}
