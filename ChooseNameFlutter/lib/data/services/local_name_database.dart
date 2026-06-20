import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/celebrity.dart';
import '../../domain/models/character.dart';
import '../../domain/models/child.dart';
import '../../domain/models/gender_type.dart';
import '../../domain/models/name_decision.dart';
import '../../domain/models/name_record.dart';
import '../../domain/models/song.dart';

part 'local_name_database.g.dart';

class LocalNames extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get gender => text()();
  TextColumn get nameId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get descriptionName => text().nullable()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get nameRu => text().nullable()();
  TextColumn get transliteration => text().nullable()();
  TextColumn get nameDays => text().nullable()();
  TextColumn get versions => text().nullable()();
  TextColumn get sameNames => text().nullable()();
  TextColumn get langs => text().nullable()();
  IntColumn get selectValue => integer().withDefault(const Constant(0))();
  BoolColumn get liked => boolean().withDefault(const Constant(false))();
}

class LocalCelebrities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameId => text()();
  TextColumn get name => text()();
  TextColumn get descriptionCelebrity => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get imgUrl => text().nullable()();
  IntColumn get sort => integer().withDefault(const Constant(0))();
}

class LocalCharacters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameId => text()();
  TextColumn get name => text()();
  TextColumn get descriptionCharacter => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get imgUrl => text().nullable()();
  IntColumn get sort => integer().withDefault(const Constant(0))();
}

class LocalSongs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameId => text()();
  TextColumn get title => text()();
  TextColumn get singer => text().nullable()();
  TextColumn get url => text().nullable()();
  IntColumn get sort => integer().withDefault(const Constant(0))();
}

class LocalChildren extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameId => text()();
  TextColumn get name => text()();
  TextColumn get parents => text().nullable()();
  IntColumn get birthday => integer().withDefault(const Constant(0))();
  IntColumn get death => integer().withDefault(const Constant(0))();
  IntColumn get sort => integer().withDefault(const Constant(0))();
}

@DriftDatabase(
  tables: <Type>[
    LocalNames,
    LocalCelebrities,
    LocalCharacters,
    LocalSongs,
    LocalChildren,
  ],
)
class LocalNameDatabase extends _$LocalNameDatabase {
  LocalNameDatabase() : super(_openConnection());

  LocalNameDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Future<List<NameRecord>> getUnseenNames(GenderType gender) async {
    final rows =
        await (select(localNames)..where(
              (table) =>
                  table.gender.equals(gender.storageValue) &
                  table.selectValue.equals(NameDecision.neutral.value),
            ))
            .get();
    return Future.wait(rows.map(_hydrateName));
  }

  Future<List<NameRecord>> getLikedNames(GenderType gender) async {
    final rows =
        await (select(localNames)..where(
              (table) =>
                  table.gender.equals(gender.storageValue) &
                  table.selectValue.equals(NameDecision.liked.value),
            ))
            .get();
    return Future.wait(rows.map(_hydrateName));
  }

  Future<NameRecord?> findNameByExactText(
    GenderType gender,
    String name,
  ) async {
    final row =
        await (select(localNames)
              ..where(
                (table) =>
                    table.gender.equals(gender.storageValue) &
                    table.name.equals(name),
              )
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _hydrateName(row);
  }

  Future<List<NameRecord>> searchNames(GenderType gender, String search) async {
    final rows =
        await (select(localNames)..where(
              (table) =>
                  table.gender.equals(gender.storageValue) &
                  (table.name.like('$search%') |
                      table.versions.like('%$search%')),
            ))
            .get();
    return Future.wait(rows.map(_hydrateName));
  }

  Future<void> upsertName(GenderType gender, NameRecord name) async {
    await transaction(() async {
      final existing = name.nameId == null
          ? null
          : await _findRowByNameId(gender, name.nameId!);
      final companion = LocalNamesCompanion(
        gender: Value(gender.storageValue),
        nameId: Value(name.nameId),
        name: Value(name.name),
        descriptionName: Value(name.description),
        nameEn: Value(name.nameEng),
        nameRu: Value(name.nameRu),
        transliteration: Value(name.transliteration),
        nameDays: Value(name.days),
        versions: Value(name.versions),
        sameNames: Value(name.sameNames),
        langs: Value(name.langs),
        selectValue: Value(name.decision.value),
        liked: Value(name.isChosenFavorite),
      );
      if (existing == null) {
        await into(localNames).insert(companion);
      } else {
        await (update(
          localNames,
        )..where((table) => table.id.equals(existing.id))).write(companion);
      }
      if (name.nameId != null) {
        await _replaceRelatedRecords(name);
      }
    });
  }

  Future<void> addCustomLikedName(GenderType gender, String name) async {
    await into(localNames).insert(
      LocalNamesCompanion.insert(
        gender: gender.storageValue,
        name: name,
        nameId: const Value(null),
        selectValue: Value(NameDecision.liked.value),
      ),
    );
  }

  Future<void> setDecision(
    GenderType gender,
    String nameId,
    NameDecision decision,
  ) async {
    await (update(localNames)..where(
          (table) =>
              table.gender.equals(gender.storageValue) &
              table.nameId.equals(nameId),
        ))
        .write(
          LocalNamesCompanion(
            selectValue: Value(decision.value),
            liked: const Value(false),
          ),
        );
  }

  Future<void> resetDislikedNames(GenderType gender) async {
    await (update(localNames)..where(
          (table) =>
              table.gender.equals(gender.storageValue) &
              table.selectValue.equals(NameDecision.disliked.value),
        ))
        .write(
          LocalNamesCompanion(
            selectValue: Value(NameDecision.neutral.value),
            liked: const Value(false),
          ),
        );
  }

  Future<void> chooseFavorite(GenderType gender, String nameId) async {
    await transaction(() async {
      await (update(localNames)..where(
            (table) =>
                table.gender.equals(gender.storageValue) &
                table.selectValue.equals(NameDecision.liked.value),
          ))
          .write(const LocalNamesCompanion(liked: Value(false)));
      await (update(localNames)..where(
            (table) =>
                table.gender.equals(gender.storageValue) &
                table.nameId.equals(nameId),
          ))
          .write(
            LocalNamesCompanion(
              selectValue: Value(NameDecision.liked.value),
              liked: const Value(true),
            ),
          );
    });
  }

  Future<void> removeByName(GenderType gender, String name) async {
    await (delete(localNames)..where(
          (table) =>
              table.gender.equals(gender.storageValue) &
              table.name.equals(name),
        ))
        .go();
  }

  Future<void> clearAll() async {
    await transaction(() async {
      await delete(localChildren).go();
      await delete(localSongs).go();
      await delete(localCharacters).go();
      await delete(localCelebrities).go();
      await delete(localNames).go();
    });
  }

  Future<LocalName?> _findRowByNameId(GenderType gender, String nameId) {
    return (select(localNames)
          ..where(
            (table) =>
                table.gender.equals(gender.storageValue) &
                table.nameId.equals(nameId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<NameRecord> _hydrateName(LocalName row) async {
    final nameId = row.nameId;
    if (nameId == null) {
      return _toDomain(row);
    }
    final celebrities =
        await (select(localCelebrities)
              ..where((table) => table.nameId.equals(nameId))
              ..orderBy(<OrderingTerm Function($LocalCelebritiesTable)>[
                (table) => OrderingTerm.desc(table.sort),
              ]))
            .get();
    final characters =
        await (select(localCharacters)
              ..where((table) => table.nameId.equals(nameId))
              ..orderBy(<OrderingTerm Function($LocalCharactersTable)>[
                (table) => OrderingTerm.desc(table.sort),
              ]))
            .get();
    final songs =
        await (select(localSongs)
              ..where((table) => table.nameId.equals(nameId))
              ..orderBy(<OrderingTerm Function($LocalSongsTable)>[
                (table) => OrderingTerm.desc(table.sort),
              ]))
            .get();
    final children =
        await (select(localChildren)
              ..where((table) => table.nameId.equals(nameId))
              ..orderBy(<OrderingTerm Function($LocalChildrenTable)>[
                (table) => OrderingTerm.desc(table.sort),
              ]))
            .get();
    return _toDomain(
      row,
      celebrities: celebrities,
      characters: characters,
      songs: songs,
      children: children,
    );
  }

  NameRecord _toDomain(
    LocalName row, {
    List<LocalCelebrity> celebrities = const <LocalCelebrity>[],
    List<LocalCharacter> characters = const <LocalCharacter>[],
    List<LocalSong> songs = const <LocalSong>[],
    List<LocalChildrenData> children = const <LocalChildrenData>[],
  }) {
    return NameRecord(
      nameId: row.nameId,
      name: row.name,
      versions: row.versions,
      days: row.nameDays,
      description: row.descriptionName,
      nameEng: row.nameEn,
      nameRu: row.nameRu,
      transliteration: row.transliteration,
      sameNames: row.sameNames,
      langs: row.langs,
      decision: NameDecision.fromValue(row.selectValue),
      isChosenFavorite: row.liked,
      celebrities: celebrities
          .map(
            (row) => Celebrity(
              name: row.name,
              url: row.url,
              photo: row.imgUrl,
              description: row.descriptionCelebrity,
              sort: row.sort,
            ),
          )
          .toList(),
      characters: characters
          .map(
            (row) => Character(
              name: row.name,
              url: row.url,
              photo: row.imgUrl,
              description: row.descriptionCharacter,
              sort: row.sort,
            ),
          )
          .toList(),
      songs: songs
          .map(
            (row) => Song(
              title: row.title,
              singer: row.singer,
              url: row.url,
              sort: row.sort,
            ),
          )
          .toList(),
      children: children
          .map(
            (row) => Child(
              name: row.name,
              parents: row.parents,
              birthday: row.birthday,
              yearOfDeath: row.death,
              sort: row.sort,
            ),
          )
          .toList(),
    );
  }

  Future<void> _replaceRelatedRecords(NameRecord name) async {
    final nameId = name.nameId!;
    await (delete(
      localCelebrities,
    )..where((table) => table.nameId.equals(nameId))).go();
    await (delete(
      localCharacters,
    )..where((table) => table.nameId.equals(nameId))).go();
    await (delete(
      localSongs,
    )..where((table) => table.nameId.equals(nameId))).go();
    await (delete(
      localChildren,
    )..where((table) => table.nameId.equals(nameId))).go();
    await batch((batch) {
      batch.insertAll(
        localCelebrities,
        name.celebrities.map(
          (item) => LocalCelebritiesCompanion.insert(
            nameId: nameId,
            name: item.name,
            descriptionCelebrity: Value(item.description),
            url: Value(item.url),
            imgUrl: Value(item.photo),
            sort: Value(item.sort),
          ),
        ),
      );
      batch.insertAll(
        localCharacters,
        name.characters.map(
          (item) => LocalCharactersCompanion.insert(
            nameId: nameId,
            name: item.name,
            descriptionCharacter: Value(item.description),
            url: Value(item.url),
            imgUrl: Value(item.photo),
            sort: Value(item.sort),
          ),
        ),
      );
      batch.insertAll(
        localSongs,
        name.songs.map(
          (item) => LocalSongsCompanion.insert(
            nameId: nameId,
            title: item.title,
            singer: Value(item.singer),
            url: Value(item.url),
            sort: Value(item.sort),
          ),
        ),
      );
      batch.insertAll(
        localChildren,
        name.children.map(
          (item) => LocalChildrenCompanion.insert(
            nameId: nameId,
            name: item.name,
            parents: Value(item.parents),
            birthday: Value(item.birthday),
            death: Value(item.yearOfDeath),
            sort: Value(item.sort),
          ),
        ),
      );
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = await _databaseFile();
    return NativeDatabase.createInBackground(file);
  });
}

Future<File> _databaseFile() async {
  if (Platform.isAndroid) {
    final directory = Directory(
      '/data/user/0/com.itworksinua.BabysName2/databases',
    );
    await directory.create(recursive: true);
    return File(p.join(directory.path, 'choose_name.sqlite'));
  }

  final file = File(p.join(Directory.current.path, 'choose_name.sqlite'));
  await file.parent.create(recursive: true);
  return file;
}
