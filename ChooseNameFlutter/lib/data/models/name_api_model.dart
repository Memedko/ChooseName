import '../../domain/models/celebrity.dart';
import '../../domain/models/character.dart';
import '../../domain/models/child.dart';
import '../../domain/models/name_record.dart';
import '../../domain/models/song.dart';

class NameApiModel {
  const NameApiModel({
    required this.nameId,
    required this.name,
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
    this.sameNames,
    this.langs,
  });

  final String nameId;
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
  final String? sameNames;
  final String? langs;

  factory NameApiModel.fromJson(
    Map<String, Object?> json, {
    required String nameId,
  }) {
    return NameApiModel(
      nameId: nameId,
      name: _string(json['name']),
      versions: _optionalString(json['versions']),
      days: _optionalString(json['nameDays']),
      description: _optionalString(json['description']),
      nameEng: _optionalString(json['name_en']),
      nameRu: _optionalString(json['name_ru']),
      transliteration: _optionalString(json['transliteration']),
      celebrities:
          _list(json['celebrities']).map(CelebrityApiModel.fromJson).toList()
            ..sort((a, b) => b.sort.compareTo(a.sort)),
      characters:
          _list(json['characters']).map(CharacterApiModel.fromJson).toList()
            ..sort((a, b) => b.sort.compareTo(a.sort)),
      songs: _list(json['songs']).map(SongApiModel.fromJson).toList()
        ..sort((a, b) => b.sort.compareTo(a.sort)),
      children: _list(json['children']).map(ChildApiModel.fromJson).toList()
        ..sort((a, b) => b.sort.compareTo(a.sort)),
      sameNames: _optionalText(json['sameNames']),
      langs: _optionalString(json['langs']),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'name': name,
      'versions': versions,
      'nameDays': days,
      'description': description,
      'name_en': nameEng,
      'name_ru': nameRu,
      'transliteration': transliteration,
      'celebrities': celebrities.map(CelebrityApiModel.toJson).toList(),
      'characters': characters.map(CharacterApiModel.toJson).toList(),
      'songs': songs.map(SongApiModel.toJson).toList(),
      'children': children.map(ChildApiModel.toJson).toList(),
      'sameNames': sameNames,
      'langs': langs,
    };
  }

  NameRecord toDomain() {
    return NameRecord(
      nameId: nameId,
      name: name,
      versions: versions,
      days: days,
      description: description,
      nameEng: nameEng,
      nameRu: nameRu,
      transliteration: transliteration,
      celebrities: celebrities,
      songs: songs,
      characters: characters,
      children: children,
      sameNames: sameNames,
      langs: langs,
    );
  }
}

class CelebrityApiModel {
  const CelebrityApiModel._();

  static Celebrity fromJson(Map<String, Object?> json) {
    return Celebrity(
      name: _string(json['name']),
      url: _optionalString(json['url']),
      photo: _optionalString(json['imgUrl']),
      description: _optionalString(json['description']),
      sort: _int(json['sort']),
    );
  }

  static Map<String, Object?> toJson(Celebrity celebrity) {
    return <String, Object?>{
      'name': celebrity.name,
      'url': celebrity.url,
      'imgUrl': celebrity.photo,
      'description': celebrity.description,
      'sort': celebrity.sort,
    };
  }
}

class CharacterApiModel {
  const CharacterApiModel._();

  static Character fromJson(Map<String, Object?> json) {
    return Character(
      name: _string(json['name']),
      url: _optionalString(json['url']),
      photo: _optionalString(json['imgUrl']),
      description: _optionalString(json['description']),
      sort: _int(json['sort']),
    );
  }

  static Map<String, Object?> toJson(Character character) {
    return <String, Object?>{
      'name': character.name,
      'url': character.url,
      'imgUrl': character.photo,
      'description': character.description,
      'sort': character.sort,
    };
  }
}

class SongApiModel {
  const SongApiModel._();

  static Song fromJson(Map<String, Object?> json) {
    return Song(
      title: _string(json['title']),
      singer: _optionalString(json['singer']),
      url: _optionalString(json['url']),
      sort: _int(json['sort']),
    );
  }

  static Map<String, Object?> toJson(Song song) {
    return <String, Object?>{
      'title': song.title,
      'singer': song.singer,
      'url': song.url,
      'sort': song.sort,
    };
  }
}

class ChildApiModel {
  const ChildApiModel._();

  static Child fromJson(Map<String, Object?> json) {
    return Child(
      name: _string(json['name']),
      parents: _optionalString(json['parents']),
      birthday: _int(json['birthday']),
      yearOfDeath: _int(json['yearOfDeath']),
      sort: _int(json['sort']),
    );
  }

  static Map<String, Object?> toJson(Child child) {
    return <String, Object?>{
      'name': child.name,
      'parents': child.parents,
      'birthday': child.birthday,
      'yearOfDeath': child.yearOfDeath,
      'sort': child.sort,
    };
  }
}

List<Map<String, Object?>> _list(Object? value) {
  if (value is! List<Object?>) {
    return const <Map<String, Object?>>[];
  }
  return value.whereType<Map<Object?, Object?>>().map((item) {
    return item.map((key, value) => MapEntry(key.toString(), value));
  }).toList();
}

String _string(Object? value) => value is String ? value : '';

String? _optionalString(Object? value) {
  return value is String && value.isNotEmpty ? value : null;
}

String? _optionalText(Object? value) {
  if (value is String && value.isNotEmpty) {
    return value;
  }
  if (value is List<Object?>) {
    final text = value
        .whereType<String>()
        .where((item) => item.trim().isNotEmpty)
        .join('\n');
    return text.isEmpty ? null : text;
  }
  return null;
}

int _int(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return 0;
}
