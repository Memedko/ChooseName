// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_name_database.dart';

// ignore_for_file: type=lint
class $LocalNamesTable extends LocalNames
    with TableInfo<$LocalNamesTable, LocalName> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalNamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<String> nameId = GeneratedColumn<String>(
    'name_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionNameMeta = const VerificationMeta(
    'descriptionName',
  );
  @override
  late final GeneratedColumn<String> descriptionName = GeneratedColumn<String>(
    'description_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameRuMeta = const VerificationMeta('nameRu');
  @override
  late final GeneratedColumn<String> nameRu = GeneratedColumn<String>(
    'name_ru',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameDaysMeta = const VerificationMeta(
    'nameDays',
  );
  @override
  late final GeneratedColumn<String> nameDays = GeneratedColumn<String>(
    'name_days',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionsMeta = const VerificationMeta(
    'versions',
  );
  @override
  late final GeneratedColumn<String> versions = GeneratedColumn<String>(
    'versions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sameNamesMeta = const VerificationMeta(
    'sameNames',
  );
  @override
  late final GeneratedColumn<String> sameNames = GeneratedColumn<String>(
    'same_names',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _langsMeta = const VerificationMeta('langs');
  @override
  late final GeneratedColumn<String> langs = GeneratedColumn<String>(
    'langs',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectValueMeta = const VerificationMeta(
    'selectValue',
  );
  @override
  late final GeneratedColumn<int> selectValue = GeneratedColumn<int>(
    'select_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _likedMeta = const VerificationMeta('liked');
  @override
  late final GeneratedColumn<bool> liked = GeneratedColumn<bool>(
    'liked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("liked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gender,
    nameId,
    name,
    descriptionName,
    nameEn,
    nameRu,
    transliteration,
    nameDays,
    versions,
    sameNames,
    langs,
    selectValue,
    liked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_names';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalName> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('name_id')) {
      context.handle(
        _nameIdMeta,
        nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description_name')) {
      context.handle(
        _descriptionNameMeta,
        descriptionName.isAcceptableOrUnknown(
          data['description_name']!,
          _descriptionNameMeta,
        ),
      );
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('name_ru')) {
      context.handle(
        _nameRuMeta,
        nameRu.isAcceptableOrUnknown(data['name_ru']!, _nameRuMeta),
      );
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    }
    if (data.containsKey('name_days')) {
      context.handle(
        _nameDaysMeta,
        nameDays.isAcceptableOrUnknown(data['name_days']!, _nameDaysMeta),
      );
    }
    if (data.containsKey('versions')) {
      context.handle(
        _versionsMeta,
        versions.isAcceptableOrUnknown(data['versions']!, _versionsMeta),
      );
    }
    if (data.containsKey('same_names')) {
      context.handle(
        _sameNamesMeta,
        sameNames.isAcceptableOrUnknown(data['same_names']!, _sameNamesMeta),
      );
    }
    if (data.containsKey('langs')) {
      context.handle(
        _langsMeta,
        langs.isAcceptableOrUnknown(data['langs']!, _langsMeta),
      );
    }
    if (data.containsKey('select_value')) {
      context.handle(
        _selectValueMeta,
        selectValue.isAcceptableOrUnknown(
          data['select_value']!,
          _selectValueMeta,
        ),
      );
    }
    if (data.containsKey('liked')) {
      context.handle(
        _likedMeta,
        liked.isAcceptableOrUnknown(data['liked']!, _likedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalName map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalName(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      nameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      descriptionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_name'],
      ),
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      nameRu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ru'],
      ),
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      ),
      nameDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_days'],
      ),
      versions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}versions'],
      ),
      sameNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}same_names'],
      ),
      langs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}langs'],
      ),
      selectValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}select_value'],
      )!,
      liked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}liked'],
      )!,
    );
  }

  @override
  $LocalNamesTable createAlias(String alias) {
    return $LocalNamesTable(attachedDatabase, alias);
  }
}

class LocalName extends DataClass implements Insertable<LocalName> {
  final int id;
  final String gender;
  final String? nameId;
  final String name;
  final String? descriptionName;
  final String? nameEn;
  final String? nameRu;
  final String? transliteration;
  final String? nameDays;
  final String? versions;
  final String? sameNames;
  final String? langs;
  final int selectValue;
  final bool liked;
  const LocalName({
    required this.id,
    required this.gender,
    this.nameId,
    required this.name,
    this.descriptionName,
    this.nameEn,
    this.nameRu,
    this.transliteration,
    this.nameDays,
    this.versions,
    this.sameNames,
    this.langs,
    required this.selectValue,
    required this.liked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['gender'] = Variable<String>(gender);
    if (!nullToAbsent || nameId != null) {
      map['name_id'] = Variable<String>(nameId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || descriptionName != null) {
      map['description_name'] = Variable<String>(descriptionName);
    }
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || nameRu != null) {
      map['name_ru'] = Variable<String>(nameRu);
    }
    if (!nullToAbsent || transliteration != null) {
      map['transliteration'] = Variable<String>(transliteration);
    }
    if (!nullToAbsent || nameDays != null) {
      map['name_days'] = Variable<String>(nameDays);
    }
    if (!nullToAbsent || versions != null) {
      map['versions'] = Variable<String>(versions);
    }
    if (!nullToAbsent || sameNames != null) {
      map['same_names'] = Variable<String>(sameNames);
    }
    if (!nullToAbsent || langs != null) {
      map['langs'] = Variable<String>(langs);
    }
    map['select_value'] = Variable<int>(selectValue);
    map['liked'] = Variable<bool>(liked);
    return map;
  }

  LocalNamesCompanion toCompanion(bool nullToAbsent) {
    return LocalNamesCompanion(
      id: Value(id),
      gender: Value(gender),
      nameId: nameId == null && nullToAbsent
          ? const Value.absent()
          : Value(nameId),
      name: Value(name),
      descriptionName: descriptionName == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionName),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      nameRu: nameRu == null && nullToAbsent
          ? const Value.absent()
          : Value(nameRu),
      transliteration: transliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(transliteration),
      nameDays: nameDays == null && nullToAbsent
          ? const Value.absent()
          : Value(nameDays),
      versions: versions == null && nullToAbsent
          ? const Value.absent()
          : Value(versions),
      sameNames: sameNames == null && nullToAbsent
          ? const Value.absent()
          : Value(sameNames),
      langs: langs == null && nullToAbsent
          ? const Value.absent()
          : Value(langs),
      selectValue: Value(selectValue),
      liked: Value(liked),
    );
  }

  factory LocalName.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalName(
      id: serializer.fromJson<int>(json['id']),
      gender: serializer.fromJson<String>(json['gender']),
      nameId: serializer.fromJson<String?>(json['nameId']),
      name: serializer.fromJson<String>(json['name']),
      descriptionName: serializer.fromJson<String?>(json['descriptionName']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      nameRu: serializer.fromJson<String?>(json['nameRu']),
      transliteration: serializer.fromJson<String?>(json['transliteration']),
      nameDays: serializer.fromJson<String?>(json['nameDays']),
      versions: serializer.fromJson<String?>(json['versions']),
      sameNames: serializer.fromJson<String?>(json['sameNames']),
      langs: serializer.fromJson<String?>(json['langs']),
      selectValue: serializer.fromJson<int>(json['selectValue']),
      liked: serializer.fromJson<bool>(json['liked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gender': serializer.toJson<String>(gender),
      'nameId': serializer.toJson<String?>(nameId),
      'name': serializer.toJson<String>(name),
      'descriptionName': serializer.toJson<String?>(descriptionName),
      'nameEn': serializer.toJson<String?>(nameEn),
      'nameRu': serializer.toJson<String?>(nameRu),
      'transliteration': serializer.toJson<String?>(transliteration),
      'nameDays': serializer.toJson<String?>(nameDays),
      'versions': serializer.toJson<String?>(versions),
      'sameNames': serializer.toJson<String?>(sameNames),
      'langs': serializer.toJson<String?>(langs),
      'selectValue': serializer.toJson<int>(selectValue),
      'liked': serializer.toJson<bool>(liked),
    };
  }

  LocalName copyWith({
    int? id,
    String? gender,
    Value<String?> nameId = const Value.absent(),
    String? name,
    Value<String?> descriptionName = const Value.absent(),
    Value<String?> nameEn = const Value.absent(),
    Value<String?> nameRu = const Value.absent(),
    Value<String?> transliteration = const Value.absent(),
    Value<String?> nameDays = const Value.absent(),
    Value<String?> versions = const Value.absent(),
    Value<String?> sameNames = const Value.absent(),
    Value<String?> langs = const Value.absent(),
    int? selectValue,
    bool? liked,
  }) => LocalName(
    id: id ?? this.id,
    gender: gender ?? this.gender,
    nameId: nameId.present ? nameId.value : this.nameId,
    name: name ?? this.name,
    descriptionName: descriptionName.present
        ? descriptionName.value
        : this.descriptionName,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    nameRu: nameRu.present ? nameRu.value : this.nameRu,
    transliteration: transliteration.present
        ? transliteration.value
        : this.transliteration,
    nameDays: nameDays.present ? nameDays.value : this.nameDays,
    versions: versions.present ? versions.value : this.versions,
    sameNames: sameNames.present ? sameNames.value : this.sameNames,
    langs: langs.present ? langs.value : this.langs,
    selectValue: selectValue ?? this.selectValue,
    liked: liked ?? this.liked,
  );
  LocalName copyWithCompanion(LocalNamesCompanion data) {
    return LocalName(
      id: data.id.present ? data.id.value : this.id,
      gender: data.gender.present ? data.gender.value : this.gender,
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      name: data.name.present ? data.name.value : this.name,
      descriptionName: data.descriptionName.present
          ? data.descriptionName.value
          : this.descriptionName,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameRu: data.nameRu.present ? data.nameRu.value : this.nameRu,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      nameDays: data.nameDays.present ? data.nameDays.value : this.nameDays,
      versions: data.versions.present ? data.versions.value : this.versions,
      sameNames: data.sameNames.present ? data.sameNames.value : this.sameNames,
      langs: data.langs.present ? data.langs.value : this.langs,
      selectValue: data.selectValue.present
          ? data.selectValue.value
          : this.selectValue,
      liked: data.liked.present ? data.liked.value : this.liked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalName(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('descriptionName: $descriptionName, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameRu: $nameRu, ')
          ..write('transliteration: $transliteration, ')
          ..write('nameDays: $nameDays, ')
          ..write('versions: $versions, ')
          ..write('sameNames: $sameNames, ')
          ..write('langs: $langs, ')
          ..write('selectValue: $selectValue, ')
          ..write('liked: $liked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gender,
    nameId,
    name,
    descriptionName,
    nameEn,
    nameRu,
    transliteration,
    nameDays,
    versions,
    sameNames,
    langs,
    selectValue,
    liked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalName &&
          other.id == this.id &&
          other.gender == this.gender &&
          other.nameId == this.nameId &&
          other.name == this.name &&
          other.descriptionName == this.descriptionName &&
          other.nameEn == this.nameEn &&
          other.nameRu == this.nameRu &&
          other.transliteration == this.transliteration &&
          other.nameDays == this.nameDays &&
          other.versions == this.versions &&
          other.sameNames == this.sameNames &&
          other.langs == this.langs &&
          other.selectValue == this.selectValue &&
          other.liked == this.liked);
}

class LocalNamesCompanion extends UpdateCompanion<LocalName> {
  final Value<int> id;
  final Value<String> gender;
  final Value<String?> nameId;
  final Value<String> name;
  final Value<String?> descriptionName;
  final Value<String?> nameEn;
  final Value<String?> nameRu;
  final Value<String?> transliteration;
  final Value<String?> nameDays;
  final Value<String?> versions;
  final Value<String?> sameNames;
  final Value<String?> langs;
  final Value<int> selectValue;
  final Value<bool> liked;
  const LocalNamesCompanion({
    this.id = const Value.absent(),
    this.gender = const Value.absent(),
    this.nameId = const Value.absent(),
    this.name = const Value.absent(),
    this.descriptionName = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameRu = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.nameDays = const Value.absent(),
    this.versions = const Value.absent(),
    this.sameNames = const Value.absent(),
    this.langs = const Value.absent(),
    this.selectValue = const Value.absent(),
    this.liked = const Value.absent(),
  });
  LocalNamesCompanion.insert({
    this.id = const Value.absent(),
    required String gender,
    this.nameId = const Value.absent(),
    required String name,
    this.descriptionName = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameRu = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.nameDays = const Value.absent(),
    this.versions = const Value.absent(),
    this.sameNames = const Value.absent(),
    this.langs = const Value.absent(),
    this.selectValue = const Value.absent(),
    this.liked = const Value.absent(),
  }) : gender = Value(gender),
       name = Value(name);
  static Insertable<LocalName> custom({
    Expression<int>? id,
    Expression<String>? gender,
    Expression<String>? nameId,
    Expression<String>? name,
    Expression<String>? descriptionName,
    Expression<String>? nameEn,
    Expression<String>? nameRu,
    Expression<String>? transliteration,
    Expression<String>? nameDays,
    Expression<String>? versions,
    Expression<String>? sameNames,
    Expression<String>? langs,
    Expression<int>? selectValue,
    Expression<bool>? liked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gender != null) 'gender': gender,
      if (nameId != null) 'name_id': nameId,
      if (name != null) 'name': name,
      if (descriptionName != null) 'description_name': descriptionName,
      if (nameEn != null) 'name_en': nameEn,
      if (nameRu != null) 'name_ru': nameRu,
      if (transliteration != null) 'transliteration': transliteration,
      if (nameDays != null) 'name_days': nameDays,
      if (versions != null) 'versions': versions,
      if (sameNames != null) 'same_names': sameNames,
      if (langs != null) 'langs': langs,
      if (selectValue != null) 'select_value': selectValue,
      if (liked != null) 'liked': liked,
    });
  }

  LocalNamesCompanion copyWith({
    Value<int>? id,
    Value<String>? gender,
    Value<String?>? nameId,
    Value<String>? name,
    Value<String?>? descriptionName,
    Value<String?>? nameEn,
    Value<String?>? nameRu,
    Value<String?>? transliteration,
    Value<String?>? nameDays,
    Value<String?>? versions,
    Value<String?>? sameNames,
    Value<String?>? langs,
    Value<int>? selectValue,
    Value<bool>? liked,
  }) {
    return LocalNamesCompanion(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      nameId: nameId ?? this.nameId,
      name: name ?? this.name,
      descriptionName: descriptionName ?? this.descriptionName,
      nameEn: nameEn ?? this.nameEn,
      nameRu: nameRu ?? this.nameRu,
      transliteration: transliteration ?? this.transliteration,
      nameDays: nameDays ?? this.nameDays,
      versions: versions ?? this.versions,
      sameNames: sameNames ?? this.sameNames,
      langs: langs ?? this.langs,
      selectValue: selectValue ?? this.selectValue,
      liked: liked ?? this.liked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (nameId.present) {
      map['name_id'] = Variable<String>(nameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (descriptionName.present) {
      map['description_name'] = Variable<String>(descriptionName.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameRu.present) {
      map['name_ru'] = Variable<String>(nameRu.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (nameDays.present) {
      map['name_days'] = Variable<String>(nameDays.value);
    }
    if (versions.present) {
      map['versions'] = Variable<String>(versions.value);
    }
    if (sameNames.present) {
      map['same_names'] = Variable<String>(sameNames.value);
    }
    if (langs.present) {
      map['langs'] = Variable<String>(langs.value);
    }
    if (selectValue.present) {
      map['select_value'] = Variable<int>(selectValue.value);
    }
    if (liked.present) {
      map['liked'] = Variable<bool>(liked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalNamesCompanion(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('descriptionName: $descriptionName, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameRu: $nameRu, ')
          ..write('transliteration: $transliteration, ')
          ..write('nameDays: $nameDays, ')
          ..write('versions: $versions, ')
          ..write('sameNames: $sameNames, ')
          ..write('langs: $langs, ')
          ..write('selectValue: $selectValue, ')
          ..write('liked: $liked')
          ..write(')'))
        .toString();
  }
}

class $LocalCelebritiesTable extends LocalCelebrities
    with TableInfo<$LocalCelebritiesTable, LocalCelebrity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCelebritiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<String> nameId = GeneratedColumn<String>(
    'name_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionCelebrityMeta =
      const VerificationMeta('descriptionCelebrity');
  @override
  late final GeneratedColumn<String> descriptionCelebrity =
      GeneratedColumn<String>(
        'description_celebrity',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imgUrlMeta = const VerificationMeta('imgUrl');
  @override
  late final GeneratedColumn<String> imgUrl = GeneratedColumn<String>(
    'img_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
    'sort',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameId,
    name,
    descriptionCelebrity,
    url,
    imgUrl,
    sort,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_celebrities';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCelebrity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_id')) {
      context.handle(
        _nameIdMeta,
        nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description_celebrity')) {
      context.handle(
        _descriptionCelebrityMeta,
        descriptionCelebrity.isAcceptableOrUnknown(
          data['description_celebrity']!,
          _descriptionCelebrityMeta,
        ),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('img_url')) {
      context.handle(
        _imgUrlMeta,
        imgUrl.isAcceptableOrUnknown(data['img_url']!, _imgUrlMeta),
      );
    }
    if (data.containsKey('sort')) {
      context.handle(
        _sortMeta,
        sort.isAcceptableOrUnknown(data['sort']!, _sortMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCelebrity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCelebrity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      descriptionCelebrity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_celebrity'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      imgUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}img_url'],
      ),
      sort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort'],
      )!,
    );
  }

  @override
  $LocalCelebritiesTable createAlias(String alias) {
    return $LocalCelebritiesTable(attachedDatabase, alias);
  }
}

class LocalCelebrity extends DataClass implements Insertable<LocalCelebrity> {
  final int id;
  final String nameId;
  final String name;
  final String? descriptionCelebrity;
  final String? url;
  final String? imgUrl;
  final int sort;
  const LocalCelebrity({
    required this.id,
    required this.nameId,
    required this.name,
    this.descriptionCelebrity,
    this.url,
    this.imgUrl,
    required this.sort,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_id'] = Variable<String>(nameId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || descriptionCelebrity != null) {
      map['description_celebrity'] = Variable<String>(descriptionCelebrity);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || imgUrl != null) {
      map['img_url'] = Variable<String>(imgUrl);
    }
    map['sort'] = Variable<int>(sort);
    return map;
  }

  LocalCelebritiesCompanion toCompanion(bool nullToAbsent) {
    return LocalCelebritiesCompanion(
      id: Value(id),
      nameId: Value(nameId),
      name: Value(name),
      descriptionCelebrity: descriptionCelebrity == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionCelebrity),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      imgUrl: imgUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imgUrl),
      sort: Value(sort),
    );
  }

  factory LocalCelebrity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCelebrity(
      id: serializer.fromJson<int>(json['id']),
      nameId: serializer.fromJson<String>(json['nameId']),
      name: serializer.fromJson<String>(json['name']),
      descriptionCelebrity: serializer.fromJson<String?>(
        json['descriptionCelebrity'],
      ),
      url: serializer.fromJson<String?>(json['url']),
      imgUrl: serializer.fromJson<String?>(json['imgUrl']),
      sort: serializer.fromJson<int>(json['sort']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameId': serializer.toJson<String>(nameId),
      'name': serializer.toJson<String>(name),
      'descriptionCelebrity': serializer.toJson<String?>(descriptionCelebrity),
      'url': serializer.toJson<String?>(url),
      'imgUrl': serializer.toJson<String?>(imgUrl),
      'sort': serializer.toJson<int>(sort),
    };
  }

  LocalCelebrity copyWith({
    int? id,
    String? nameId,
    String? name,
    Value<String?> descriptionCelebrity = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> imgUrl = const Value.absent(),
    int? sort,
  }) => LocalCelebrity(
    id: id ?? this.id,
    nameId: nameId ?? this.nameId,
    name: name ?? this.name,
    descriptionCelebrity: descriptionCelebrity.present
        ? descriptionCelebrity.value
        : this.descriptionCelebrity,
    url: url.present ? url.value : this.url,
    imgUrl: imgUrl.present ? imgUrl.value : this.imgUrl,
    sort: sort ?? this.sort,
  );
  LocalCelebrity copyWithCompanion(LocalCelebritiesCompanion data) {
    return LocalCelebrity(
      id: data.id.present ? data.id.value : this.id,
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      name: data.name.present ? data.name.value : this.name,
      descriptionCelebrity: data.descriptionCelebrity.present
          ? data.descriptionCelebrity.value
          : this.descriptionCelebrity,
      url: data.url.present ? data.url.value : this.url,
      imgUrl: data.imgUrl.present ? data.imgUrl.value : this.imgUrl,
      sort: data.sort.present ? data.sort.value : this.sort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCelebrity(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('descriptionCelebrity: $descriptionCelebrity, ')
          ..write('url: $url, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameId, name, descriptionCelebrity, url, imgUrl, sort);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCelebrity &&
          other.id == this.id &&
          other.nameId == this.nameId &&
          other.name == this.name &&
          other.descriptionCelebrity == this.descriptionCelebrity &&
          other.url == this.url &&
          other.imgUrl == this.imgUrl &&
          other.sort == this.sort);
}

class LocalCelebritiesCompanion extends UpdateCompanion<LocalCelebrity> {
  final Value<int> id;
  final Value<String> nameId;
  final Value<String> name;
  final Value<String?> descriptionCelebrity;
  final Value<String?> url;
  final Value<String?> imgUrl;
  final Value<int> sort;
  const LocalCelebritiesCompanion({
    this.id = const Value.absent(),
    this.nameId = const Value.absent(),
    this.name = const Value.absent(),
    this.descriptionCelebrity = const Value.absent(),
    this.url = const Value.absent(),
    this.imgUrl = const Value.absent(),
    this.sort = const Value.absent(),
  });
  LocalCelebritiesCompanion.insert({
    this.id = const Value.absent(),
    required String nameId,
    required String name,
    this.descriptionCelebrity = const Value.absent(),
    this.url = const Value.absent(),
    this.imgUrl = const Value.absent(),
    this.sort = const Value.absent(),
  }) : nameId = Value(nameId),
       name = Value(name);
  static Insertable<LocalCelebrity> custom({
    Expression<int>? id,
    Expression<String>? nameId,
    Expression<String>? name,
    Expression<String>? descriptionCelebrity,
    Expression<String>? url,
    Expression<String>? imgUrl,
    Expression<int>? sort,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameId != null) 'name_id': nameId,
      if (name != null) 'name': name,
      if (descriptionCelebrity != null)
        'description_celebrity': descriptionCelebrity,
      if (url != null) 'url': url,
      if (imgUrl != null) 'img_url': imgUrl,
      if (sort != null) 'sort': sort,
    });
  }

  LocalCelebritiesCompanion copyWith({
    Value<int>? id,
    Value<String>? nameId,
    Value<String>? name,
    Value<String?>? descriptionCelebrity,
    Value<String?>? url,
    Value<String?>? imgUrl,
    Value<int>? sort,
  }) {
    return LocalCelebritiesCompanion(
      id: id ?? this.id,
      nameId: nameId ?? this.nameId,
      name: name ?? this.name,
      descriptionCelebrity: descriptionCelebrity ?? this.descriptionCelebrity,
      url: url ?? this.url,
      imgUrl: imgUrl ?? this.imgUrl,
      sort: sort ?? this.sort,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameId.present) {
      map['name_id'] = Variable<String>(nameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (descriptionCelebrity.present) {
      map['description_celebrity'] = Variable<String>(
        descriptionCelebrity.value,
      );
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (imgUrl.present) {
      map['img_url'] = Variable<String>(imgUrl.value);
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCelebritiesCompanion(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('descriptionCelebrity: $descriptionCelebrity, ')
          ..write('url: $url, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }
}

class $LocalCharactersTable extends LocalCharacters
    with TableInfo<$LocalCharactersTable, LocalCharacter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<String> nameId = GeneratedColumn<String>(
    'name_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionCharacterMeta =
      const VerificationMeta('descriptionCharacter');
  @override
  late final GeneratedColumn<String> descriptionCharacter =
      GeneratedColumn<String>(
        'description_character',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imgUrlMeta = const VerificationMeta('imgUrl');
  @override
  late final GeneratedColumn<String> imgUrl = GeneratedColumn<String>(
    'img_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
    'sort',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameId,
    name,
    descriptionCharacter,
    url,
    imgUrl,
    sort,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCharacter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_id')) {
      context.handle(
        _nameIdMeta,
        nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description_character')) {
      context.handle(
        _descriptionCharacterMeta,
        descriptionCharacter.isAcceptableOrUnknown(
          data['description_character']!,
          _descriptionCharacterMeta,
        ),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('img_url')) {
      context.handle(
        _imgUrlMeta,
        imgUrl.isAcceptableOrUnknown(data['img_url']!, _imgUrlMeta),
      );
    }
    if (data.containsKey('sort')) {
      context.handle(
        _sortMeta,
        sort.isAcceptableOrUnknown(data['sort']!, _sortMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCharacter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCharacter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      descriptionCharacter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_character'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      imgUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}img_url'],
      ),
      sort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort'],
      )!,
    );
  }

  @override
  $LocalCharactersTable createAlias(String alias) {
    return $LocalCharactersTable(attachedDatabase, alias);
  }
}

class LocalCharacter extends DataClass implements Insertable<LocalCharacter> {
  final int id;
  final String nameId;
  final String name;
  final String? descriptionCharacter;
  final String? url;
  final String? imgUrl;
  final int sort;
  const LocalCharacter({
    required this.id,
    required this.nameId,
    required this.name,
    this.descriptionCharacter,
    this.url,
    this.imgUrl,
    required this.sort,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_id'] = Variable<String>(nameId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || descriptionCharacter != null) {
      map['description_character'] = Variable<String>(descriptionCharacter);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || imgUrl != null) {
      map['img_url'] = Variable<String>(imgUrl);
    }
    map['sort'] = Variable<int>(sort);
    return map;
  }

  LocalCharactersCompanion toCompanion(bool nullToAbsent) {
    return LocalCharactersCompanion(
      id: Value(id),
      nameId: Value(nameId),
      name: Value(name),
      descriptionCharacter: descriptionCharacter == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionCharacter),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      imgUrl: imgUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imgUrl),
      sort: Value(sort),
    );
  }

  factory LocalCharacter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCharacter(
      id: serializer.fromJson<int>(json['id']),
      nameId: serializer.fromJson<String>(json['nameId']),
      name: serializer.fromJson<String>(json['name']),
      descriptionCharacter: serializer.fromJson<String?>(
        json['descriptionCharacter'],
      ),
      url: serializer.fromJson<String?>(json['url']),
      imgUrl: serializer.fromJson<String?>(json['imgUrl']),
      sort: serializer.fromJson<int>(json['sort']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameId': serializer.toJson<String>(nameId),
      'name': serializer.toJson<String>(name),
      'descriptionCharacter': serializer.toJson<String?>(descriptionCharacter),
      'url': serializer.toJson<String?>(url),
      'imgUrl': serializer.toJson<String?>(imgUrl),
      'sort': serializer.toJson<int>(sort),
    };
  }

  LocalCharacter copyWith({
    int? id,
    String? nameId,
    String? name,
    Value<String?> descriptionCharacter = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> imgUrl = const Value.absent(),
    int? sort,
  }) => LocalCharacter(
    id: id ?? this.id,
    nameId: nameId ?? this.nameId,
    name: name ?? this.name,
    descriptionCharacter: descriptionCharacter.present
        ? descriptionCharacter.value
        : this.descriptionCharacter,
    url: url.present ? url.value : this.url,
    imgUrl: imgUrl.present ? imgUrl.value : this.imgUrl,
    sort: sort ?? this.sort,
  );
  LocalCharacter copyWithCompanion(LocalCharactersCompanion data) {
    return LocalCharacter(
      id: data.id.present ? data.id.value : this.id,
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      name: data.name.present ? data.name.value : this.name,
      descriptionCharacter: data.descriptionCharacter.present
          ? data.descriptionCharacter.value
          : this.descriptionCharacter,
      url: data.url.present ? data.url.value : this.url,
      imgUrl: data.imgUrl.present ? data.imgUrl.value : this.imgUrl,
      sort: data.sort.present ? data.sort.value : this.sort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCharacter(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('descriptionCharacter: $descriptionCharacter, ')
          ..write('url: $url, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameId, name, descriptionCharacter, url, imgUrl, sort);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCharacter &&
          other.id == this.id &&
          other.nameId == this.nameId &&
          other.name == this.name &&
          other.descriptionCharacter == this.descriptionCharacter &&
          other.url == this.url &&
          other.imgUrl == this.imgUrl &&
          other.sort == this.sort);
}

class LocalCharactersCompanion extends UpdateCompanion<LocalCharacter> {
  final Value<int> id;
  final Value<String> nameId;
  final Value<String> name;
  final Value<String?> descriptionCharacter;
  final Value<String?> url;
  final Value<String?> imgUrl;
  final Value<int> sort;
  const LocalCharactersCompanion({
    this.id = const Value.absent(),
    this.nameId = const Value.absent(),
    this.name = const Value.absent(),
    this.descriptionCharacter = const Value.absent(),
    this.url = const Value.absent(),
    this.imgUrl = const Value.absent(),
    this.sort = const Value.absent(),
  });
  LocalCharactersCompanion.insert({
    this.id = const Value.absent(),
    required String nameId,
    required String name,
    this.descriptionCharacter = const Value.absent(),
    this.url = const Value.absent(),
    this.imgUrl = const Value.absent(),
    this.sort = const Value.absent(),
  }) : nameId = Value(nameId),
       name = Value(name);
  static Insertable<LocalCharacter> custom({
    Expression<int>? id,
    Expression<String>? nameId,
    Expression<String>? name,
    Expression<String>? descriptionCharacter,
    Expression<String>? url,
    Expression<String>? imgUrl,
    Expression<int>? sort,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameId != null) 'name_id': nameId,
      if (name != null) 'name': name,
      if (descriptionCharacter != null)
        'description_character': descriptionCharacter,
      if (url != null) 'url': url,
      if (imgUrl != null) 'img_url': imgUrl,
      if (sort != null) 'sort': sort,
    });
  }

  LocalCharactersCompanion copyWith({
    Value<int>? id,
    Value<String>? nameId,
    Value<String>? name,
    Value<String?>? descriptionCharacter,
    Value<String?>? url,
    Value<String?>? imgUrl,
    Value<int>? sort,
  }) {
    return LocalCharactersCompanion(
      id: id ?? this.id,
      nameId: nameId ?? this.nameId,
      name: name ?? this.name,
      descriptionCharacter: descriptionCharacter ?? this.descriptionCharacter,
      url: url ?? this.url,
      imgUrl: imgUrl ?? this.imgUrl,
      sort: sort ?? this.sort,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameId.present) {
      map['name_id'] = Variable<String>(nameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (descriptionCharacter.present) {
      map['description_character'] = Variable<String>(
        descriptionCharacter.value,
      );
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (imgUrl.present) {
      map['img_url'] = Variable<String>(imgUrl.value);
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCharactersCompanion(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('descriptionCharacter: $descriptionCharacter, ')
          ..write('url: $url, ')
          ..write('imgUrl: $imgUrl, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }
}

class $LocalSongsTable extends LocalSongs
    with TableInfo<$LocalSongsTable, LocalSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<String> nameId = GeneratedColumn<String>(
    'name_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _singerMeta = const VerificationMeta('singer');
  @override
  late final GeneratedColumn<String> singer = GeneratedColumn<String>(
    'singer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
    'sort',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nameId, title, singer, url, sort];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSong> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_id')) {
      context.handle(
        _nameIdMeta,
        nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nameIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('singer')) {
      context.handle(
        _singerMeta,
        singer.isAcceptableOrUnknown(data['singer']!, _singerMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('sort')) {
      context.handle(
        _sortMeta,
        sort.isAcceptableOrUnknown(data['sort']!, _sortMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSong(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      singer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}singer'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      sort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort'],
      )!,
    );
  }

  @override
  $LocalSongsTable createAlias(String alias) {
    return $LocalSongsTable(attachedDatabase, alias);
  }
}

class LocalSong extends DataClass implements Insertable<LocalSong> {
  final int id;
  final String nameId;
  final String title;
  final String? singer;
  final String? url;
  final int sort;
  const LocalSong({
    required this.id,
    required this.nameId,
    required this.title,
    this.singer,
    this.url,
    required this.sort,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_id'] = Variable<String>(nameId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || singer != null) {
      map['singer'] = Variable<String>(singer);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['sort'] = Variable<int>(sort);
    return map;
  }

  LocalSongsCompanion toCompanion(bool nullToAbsent) {
    return LocalSongsCompanion(
      id: Value(id),
      nameId: Value(nameId),
      title: Value(title),
      singer: singer == null && nullToAbsent
          ? const Value.absent()
          : Value(singer),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      sort: Value(sort),
    );
  }

  factory LocalSong.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSong(
      id: serializer.fromJson<int>(json['id']),
      nameId: serializer.fromJson<String>(json['nameId']),
      title: serializer.fromJson<String>(json['title']),
      singer: serializer.fromJson<String?>(json['singer']),
      url: serializer.fromJson<String?>(json['url']),
      sort: serializer.fromJson<int>(json['sort']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameId': serializer.toJson<String>(nameId),
      'title': serializer.toJson<String>(title),
      'singer': serializer.toJson<String?>(singer),
      'url': serializer.toJson<String?>(url),
      'sort': serializer.toJson<int>(sort),
    };
  }

  LocalSong copyWith({
    int? id,
    String? nameId,
    String? title,
    Value<String?> singer = const Value.absent(),
    Value<String?> url = const Value.absent(),
    int? sort,
  }) => LocalSong(
    id: id ?? this.id,
    nameId: nameId ?? this.nameId,
    title: title ?? this.title,
    singer: singer.present ? singer.value : this.singer,
    url: url.present ? url.value : this.url,
    sort: sort ?? this.sort,
  );
  LocalSong copyWithCompanion(LocalSongsCompanion data) {
    return LocalSong(
      id: data.id.present ? data.id.value : this.id,
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      title: data.title.present ? data.title.value : this.title,
      singer: data.singer.present ? data.singer.value : this.singer,
      url: data.url.present ? data.url.value : this.url,
      sort: data.sort.present ? data.sort.value : this.sort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSong(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('title: $title, ')
          ..write('singer: $singer, ')
          ..write('url: $url, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nameId, title, singer, url, sort);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSong &&
          other.id == this.id &&
          other.nameId == this.nameId &&
          other.title == this.title &&
          other.singer == this.singer &&
          other.url == this.url &&
          other.sort == this.sort);
}

class LocalSongsCompanion extends UpdateCompanion<LocalSong> {
  final Value<int> id;
  final Value<String> nameId;
  final Value<String> title;
  final Value<String?> singer;
  final Value<String?> url;
  final Value<int> sort;
  const LocalSongsCompanion({
    this.id = const Value.absent(),
    this.nameId = const Value.absent(),
    this.title = const Value.absent(),
    this.singer = const Value.absent(),
    this.url = const Value.absent(),
    this.sort = const Value.absent(),
  });
  LocalSongsCompanion.insert({
    this.id = const Value.absent(),
    required String nameId,
    required String title,
    this.singer = const Value.absent(),
    this.url = const Value.absent(),
    this.sort = const Value.absent(),
  }) : nameId = Value(nameId),
       title = Value(title);
  static Insertable<LocalSong> custom({
    Expression<int>? id,
    Expression<String>? nameId,
    Expression<String>? title,
    Expression<String>? singer,
    Expression<String>? url,
    Expression<int>? sort,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameId != null) 'name_id': nameId,
      if (title != null) 'title': title,
      if (singer != null) 'singer': singer,
      if (url != null) 'url': url,
      if (sort != null) 'sort': sort,
    });
  }

  LocalSongsCompanion copyWith({
    Value<int>? id,
    Value<String>? nameId,
    Value<String>? title,
    Value<String?>? singer,
    Value<String?>? url,
    Value<int>? sort,
  }) {
    return LocalSongsCompanion(
      id: id ?? this.id,
      nameId: nameId ?? this.nameId,
      title: title ?? this.title,
      singer: singer ?? this.singer,
      url: url ?? this.url,
      sort: sort ?? this.sort,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameId.present) {
      map['name_id'] = Variable<String>(nameId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (singer.present) {
      map['singer'] = Variable<String>(singer.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSongsCompanion(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('title: $title, ')
          ..write('singer: $singer, ')
          ..write('url: $url, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }
}

class $LocalChildrenTable extends LocalChildren
    with TableInfo<$LocalChildrenTable, LocalChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameIdMeta = const VerificationMeta('nameId');
  @override
  late final GeneratedColumn<String> nameId = GeneratedColumn<String>(
    'name_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentsMeta = const VerificationMeta(
    'parents',
  );
  @override
  late final GeneratedColumn<String> parents = GeneratedColumn<String>(
    'parents',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthdayMeta = const VerificationMeta(
    'birthday',
  );
  @override
  late final GeneratedColumn<int> birthday = GeneratedColumn<int>(
    'birthday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deathMeta = const VerificationMeta('death');
  @override
  late final GeneratedColumn<int> death = GeneratedColumn<int>(
    'death',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
    'sort',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameId,
    name,
    parents,
    birthday,
    death,
    sort,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_children';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalChildrenData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_id')) {
      context.handle(
        _nameIdMeta,
        nameId.isAcceptableOrUnknown(data['name_id']!, _nameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parents')) {
      context.handle(
        _parentsMeta,
        parents.isAcceptableOrUnknown(data['parents']!, _parentsMeta),
      );
    }
    if (data.containsKey('birthday')) {
      context.handle(
        _birthdayMeta,
        birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta),
      );
    }
    if (data.containsKey('death')) {
      context.handle(
        _deathMeta,
        death.isAcceptableOrUnknown(data['death']!, _deathMeta),
      );
    }
    if (data.containsKey('sort')) {
      context.handle(
        _sortMeta,
        sort.isAcceptableOrUnknown(data['sort']!, _sortMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalChildrenData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parents: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parents'],
      ),
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birthday'],
      )!,
      death: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}death'],
      )!,
      sort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort'],
      )!,
    );
  }

  @override
  $LocalChildrenTable createAlias(String alias) {
    return $LocalChildrenTable(attachedDatabase, alias);
  }
}

class LocalChildrenData extends DataClass
    implements Insertable<LocalChildrenData> {
  final int id;
  final String nameId;
  final String name;
  final String? parents;
  final int birthday;
  final int death;
  final int sort;
  const LocalChildrenData({
    required this.id,
    required this.nameId,
    required this.name,
    this.parents,
    required this.birthday,
    required this.death,
    required this.sort,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_id'] = Variable<String>(nameId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parents != null) {
      map['parents'] = Variable<String>(parents);
    }
    map['birthday'] = Variable<int>(birthday);
    map['death'] = Variable<int>(death);
    map['sort'] = Variable<int>(sort);
    return map;
  }

  LocalChildrenCompanion toCompanion(bool nullToAbsent) {
    return LocalChildrenCompanion(
      id: Value(id),
      nameId: Value(nameId),
      name: Value(name),
      parents: parents == null && nullToAbsent
          ? const Value.absent()
          : Value(parents),
      birthday: Value(birthday),
      death: Value(death),
      sort: Value(sort),
    );
  }

  factory LocalChildrenData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalChildrenData(
      id: serializer.fromJson<int>(json['id']),
      nameId: serializer.fromJson<String>(json['nameId']),
      name: serializer.fromJson<String>(json['name']),
      parents: serializer.fromJson<String?>(json['parents']),
      birthday: serializer.fromJson<int>(json['birthday']),
      death: serializer.fromJson<int>(json['death']),
      sort: serializer.fromJson<int>(json['sort']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameId': serializer.toJson<String>(nameId),
      'name': serializer.toJson<String>(name),
      'parents': serializer.toJson<String?>(parents),
      'birthday': serializer.toJson<int>(birthday),
      'death': serializer.toJson<int>(death),
      'sort': serializer.toJson<int>(sort),
    };
  }

  LocalChildrenData copyWith({
    int? id,
    String? nameId,
    String? name,
    Value<String?> parents = const Value.absent(),
    int? birthday,
    int? death,
    int? sort,
  }) => LocalChildrenData(
    id: id ?? this.id,
    nameId: nameId ?? this.nameId,
    name: name ?? this.name,
    parents: parents.present ? parents.value : this.parents,
    birthday: birthday ?? this.birthday,
    death: death ?? this.death,
    sort: sort ?? this.sort,
  );
  LocalChildrenData copyWithCompanion(LocalChildrenCompanion data) {
    return LocalChildrenData(
      id: data.id.present ? data.id.value : this.id,
      nameId: data.nameId.present ? data.nameId.value : this.nameId,
      name: data.name.present ? data.name.value : this.name,
      parents: data.parents.present ? data.parents.value : this.parents,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      death: data.death.present ? data.death.value : this.death,
      sort: data.sort.present ? data.sort.value : this.sort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalChildrenData(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('parents: $parents, ')
          ..write('birthday: $birthday, ')
          ..write('death: $death, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameId, name, parents, birthday, death, sort);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalChildrenData &&
          other.id == this.id &&
          other.nameId == this.nameId &&
          other.name == this.name &&
          other.parents == this.parents &&
          other.birthday == this.birthday &&
          other.death == this.death &&
          other.sort == this.sort);
}

class LocalChildrenCompanion extends UpdateCompanion<LocalChildrenData> {
  final Value<int> id;
  final Value<String> nameId;
  final Value<String> name;
  final Value<String?> parents;
  final Value<int> birthday;
  final Value<int> death;
  final Value<int> sort;
  const LocalChildrenCompanion({
    this.id = const Value.absent(),
    this.nameId = const Value.absent(),
    this.name = const Value.absent(),
    this.parents = const Value.absent(),
    this.birthday = const Value.absent(),
    this.death = const Value.absent(),
    this.sort = const Value.absent(),
  });
  LocalChildrenCompanion.insert({
    this.id = const Value.absent(),
    required String nameId,
    required String name,
    this.parents = const Value.absent(),
    this.birthday = const Value.absent(),
    this.death = const Value.absent(),
    this.sort = const Value.absent(),
  }) : nameId = Value(nameId),
       name = Value(name);
  static Insertable<LocalChildrenData> custom({
    Expression<int>? id,
    Expression<String>? nameId,
    Expression<String>? name,
    Expression<String>? parents,
    Expression<int>? birthday,
    Expression<int>? death,
    Expression<int>? sort,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameId != null) 'name_id': nameId,
      if (name != null) 'name': name,
      if (parents != null) 'parents': parents,
      if (birthday != null) 'birthday': birthday,
      if (death != null) 'death': death,
      if (sort != null) 'sort': sort,
    });
  }

  LocalChildrenCompanion copyWith({
    Value<int>? id,
    Value<String>? nameId,
    Value<String>? name,
    Value<String?>? parents,
    Value<int>? birthday,
    Value<int>? death,
    Value<int>? sort,
  }) {
    return LocalChildrenCompanion(
      id: id ?? this.id,
      nameId: nameId ?? this.nameId,
      name: name ?? this.name,
      parents: parents ?? this.parents,
      birthday: birthday ?? this.birthday,
      death: death ?? this.death,
      sort: sort ?? this.sort,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameId.present) {
      map['name_id'] = Variable<String>(nameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parents.present) {
      map['parents'] = Variable<String>(parents.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<int>(birthday.value);
    }
    if (death.present) {
      map['death'] = Variable<int>(death.value);
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalChildrenCompanion(')
          ..write('id: $id, ')
          ..write('nameId: $nameId, ')
          ..write('name: $name, ')
          ..write('parents: $parents, ')
          ..write('birthday: $birthday, ')
          ..write('death: $death, ')
          ..write('sort: $sort')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalNameDatabase extends GeneratedDatabase {
  _$LocalNameDatabase(QueryExecutor e) : super(e);
  $LocalNameDatabaseManager get managers => $LocalNameDatabaseManager(this);
  late final $LocalNamesTable localNames = $LocalNamesTable(this);
  late final $LocalCelebritiesTable localCelebrities = $LocalCelebritiesTable(
    this,
  );
  late final $LocalCharactersTable localCharacters = $LocalCharactersTable(
    this,
  );
  late final $LocalSongsTable localSongs = $LocalSongsTable(this);
  late final $LocalChildrenTable localChildren = $LocalChildrenTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localNames,
    localCelebrities,
    localCharacters,
    localSongs,
    localChildren,
  ];
}

typedef $$LocalNamesTableCreateCompanionBuilder =
    LocalNamesCompanion Function({
      Value<int> id,
      required String gender,
      Value<String?> nameId,
      required String name,
      Value<String?> descriptionName,
      Value<String?> nameEn,
      Value<String?> nameRu,
      Value<String?> transliteration,
      Value<String?> nameDays,
      Value<String?> versions,
      Value<String?> sameNames,
      Value<String?> langs,
      Value<int> selectValue,
      Value<bool> liked,
    });
typedef $$LocalNamesTableUpdateCompanionBuilder =
    LocalNamesCompanion Function({
      Value<int> id,
      Value<String> gender,
      Value<String?> nameId,
      Value<String> name,
      Value<String?> descriptionName,
      Value<String?> nameEn,
      Value<String?> nameRu,
      Value<String?> transliteration,
      Value<String?> nameDays,
      Value<String?> versions,
      Value<String?> sameNames,
      Value<String?> langs,
      Value<int> selectValue,
      Value<bool> liked,
    });

class $$LocalNamesTableFilterComposer
    extends Composer<_$LocalNameDatabase, $LocalNamesTable> {
  $$LocalNamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionName => $composableBuilder(
    column: $table.descriptionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameRu => $composableBuilder(
    column: $table.nameRu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameDays => $composableBuilder(
    column: $table.nameDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get versions => $composableBuilder(
    column: $table.versions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sameNames => $composableBuilder(
    column: $table.sameNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get langs => $composableBuilder(
    column: $table.langs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectValue => $composableBuilder(
    column: $table.selectValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get liked => $composableBuilder(
    column: $table.liked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalNamesTableOrderingComposer
    extends Composer<_$LocalNameDatabase, $LocalNamesTable> {
  $$LocalNamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionName => $composableBuilder(
    column: $table.descriptionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameRu => $composableBuilder(
    column: $table.nameRu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameDays => $composableBuilder(
    column: $table.nameDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get versions => $composableBuilder(
    column: $table.versions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sameNames => $composableBuilder(
    column: $table.sameNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get langs => $composableBuilder(
    column: $table.langs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectValue => $composableBuilder(
    column: $table.selectValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get liked => $composableBuilder(
    column: $table.liked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalNamesTableAnnotationComposer
    extends Composer<_$LocalNameDatabase, $LocalNamesTable> {
  $$LocalNamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get descriptionName => $composableBuilder(
    column: $table.descriptionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameRu =>
      $composableBuilder(column: $table.nameRu, builder: (column) => column);

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameDays =>
      $composableBuilder(column: $table.nameDays, builder: (column) => column);

  GeneratedColumn<String> get versions =>
      $composableBuilder(column: $table.versions, builder: (column) => column);

  GeneratedColumn<String> get sameNames =>
      $composableBuilder(column: $table.sameNames, builder: (column) => column);

  GeneratedColumn<String> get langs =>
      $composableBuilder(column: $table.langs, builder: (column) => column);

  GeneratedColumn<int> get selectValue => $composableBuilder(
    column: $table.selectValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get liked =>
      $composableBuilder(column: $table.liked, builder: (column) => column);
}

class $$LocalNamesTableTableManager
    extends
        RootTableManager<
          _$LocalNameDatabase,
          $LocalNamesTable,
          LocalName,
          $$LocalNamesTableFilterComposer,
          $$LocalNamesTableOrderingComposer,
          $$LocalNamesTableAnnotationComposer,
          $$LocalNamesTableCreateCompanionBuilder,
          $$LocalNamesTableUpdateCompanionBuilder,
          (
            LocalName,
            BaseReferences<_$LocalNameDatabase, $LocalNamesTable, LocalName>,
          ),
          LocalName,
          PrefetchHooks Function()
        > {
  $$LocalNamesTableTableManager(_$LocalNameDatabase db, $LocalNamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalNamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalNamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalNamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String?> nameId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> descriptionName = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameRu = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> nameDays = const Value.absent(),
                Value<String?> versions = const Value.absent(),
                Value<String?> sameNames = const Value.absent(),
                Value<String?> langs = const Value.absent(),
                Value<int> selectValue = const Value.absent(),
                Value<bool> liked = const Value.absent(),
              }) => LocalNamesCompanion(
                id: id,
                gender: gender,
                nameId: nameId,
                name: name,
                descriptionName: descriptionName,
                nameEn: nameEn,
                nameRu: nameRu,
                transliteration: transliteration,
                nameDays: nameDays,
                versions: versions,
                sameNames: sameNames,
                langs: langs,
                selectValue: selectValue,
                liked: liked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String gender,
                Value<String?> nameId = const Value.absent(),
                required String name,
                Value<String?> descriptionName = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameRu = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> nameDays = const Value.absent(),
                Value<String?> versions = const Value.absent(),
                Value<String?> sameNames = const Value.absent(),
                Value<String?> langs = const Value.absent(),
                Value<int> selectValue = const Value.absent(),
                Value<bool> liked = const Value.absent(),
              }) => LocalNamesCompanion.insert(
                id: id,
                gender: gender,
                nameId: nameId,
                name: name,
                descriptionName: descriptionName,
                nameEn: nameEn,
                nameRu: nameRu,
                transliteration: transliteration,
                nameDays: nameDays,
                versions: versions,
                sameNames: sameNames,
                langs: langs,
                selectValue: selectValue,
                liked: liked,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalNamesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalNameDatabase,
      $LocalNamesTable,
      LocalName,
      $$LocalNamesTableFilterComposer,
      $$LocalNamesTableOrderingComposer,
      $$LocalNamesTableAnnotationComposer,
      $$LocalNamesTableCreateCompanionBuilder,
      $$LocalNamesTableUpdateCompanionBuilder,
      (
        LocalName,
        BaseReferences<_$LocalNameDatabase, $LocalNamesTable, LocalName>,
      ),
      LocalName,
      PrefetchHooks Function()
    >;
typedef $$LocalCelebritiesTableCreateCompanionBuilder =
    LocalCelebritiesCompanion Function({
      Value<int> id,
      required String nameId,
      required String name,
      Value<String?> descriptionCelebrity,
      Value<String?> url,
      Value<String?> imgUrl,
      Value<int> sort,
    });
typedef $$LocalCelebritiesTableUpdateCompanionBuilder =
    LocalCelebritiesCompanion Function({
      Value<int> id,
      Value<String> nameId,
      Value<String> name,
      Value<String?> descriptionCelebrity,
      Value<String?> url,
      Value<String?> imgUrl,
      Value<int> sort,
    });

class $$LocalCelebritiesTableFilterComposer
    extends Composer<_$LocalNameDatabase, $LocalCelebritiesTable> {
  $$LocalCelebritiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionCelebrity => $composableBuilder(
    column: $table.descriptionCelebrity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imgUrl => $composableBuilder(
    column: $table.imgUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCelebritiesTableOrderingComposer
    extends Composer<_$LocalNameDatabase, $LocalCelebritiesTable> {
  $$LocalCelebritiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionCelebrity => $composableBuilder(
    column: $table.descriptionCelebrity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imgUrl => $composableBuilder(
    column: $table.imgUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCelebritiesTableAnnotationComposer
    extends Composer<_$LocalNameDatabase, $LocalCelebritiesTable> {
  $$LocalCelebritiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get descriptionCelebrity => $composableBuilder(
    column: $table.descriptionCelebrity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get imgUrl =>
      $composableBuilder(column: $table.imgUrl, builder: (column) => column);

  GeneratedColumn<int> get sort =>
      $composableBuilder(column: $table.sort, builder: (column) => column);
}

class $$LocalCelebritiesTableTableManager
    extends
        RootTableManager<
          _$LocalNameDatabase,
          $LocalCelebritiesTable,
          LocalCelebrity,
          $$LocalCelebritiesTableFilterComposer,
          $$LocalCelebritiesTableOrderingComposer,
          $$LocalCelebritiesTableAnnotationComposer,
          $$LocalCelebritiesTableCreateCompanionBuilder,
          $$LocalCelebritiesTableUpdateCompanionBuilder,
          (
            LocalCelebrity,
            BaseReferences<
              _$LocalNameDatabase,
              $LocalCelebritiesTable,
              LocalCelebrity
            >,
          ),
          LocalCelebrity,
          PrefetchHooks Function()
        > {
  $$LocalCelebritiesTableTableManager(
    _$LocalNameDatabase db,
    $LocalCelebritiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCelebritiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCelebritiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCelebritiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> descriptionCelebrity = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> imgUrl = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalCelebritiesCompanion(
                id: id,
                nameId: nameId,
                name: name,
                descriptionCelebrity: descriptionCelebrity,
                url: url,
                imgUrl: imgUrl,
                sort: sort,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameId,
                required String name,
                Value<String?> descriptionCelebrity = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> imgUrl = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalCelebritiesCompanion.insert(
                id: id,
                nameId: nameId,
                name: name,
                descriptionCelebrity: descriptionCelebrity,
                url: url,
                imgUrl: imgUrl,
                sort: sort,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCelebritiesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalNameDatabase,
      $LocalCelebritiesTable,
      LocalCelebrity,
      $$LocalCelebritiesTableFilterComposer,
      $$LocalCelebritiesTableOrderingComposer,
      $$LocalCelebritiesTableAnnotationComposer,
      $$LocalCelebritiesTableCreateCompanionBuilder,
      $$LocalCelebritiesTableUpdateCompanionBuilder,
      (
        LocalCelebrity,
        BaseReferences<
          _$LocalNameDatabase,
          $LocalCelebritiesTable,
          LocalCelebrity
        >,
      ),
      LocalCelebrity,
      PrefetchHooks Function()
    >;
typedef $$LocalCharactersTableCreateCompanionBuilder =
    LocalCharactersCompanion Function({
      Value<int> id,
      required String nameId,
      required String name,
      Value<String?> descriptionCharacter,
      Value<String?> url,
      Value<String?> imgUrl,
      Value<int> sort,
    });
typedef $$LocalCharactersTableUpdateCompanionBuilder =
    LocalCharactersCompanion Function({
      Value<int> id,
      Value<String> nameId,
      Value<String> name,
      Value<String?> descriptionCharacter,
      Value<String?> url,
      Value<String?> imgUrl,
      Value<int> sort,
    });

class $$LocalCharactersTableFilterComposer
    extends Composer<_$LocalNameDatabase, $LocalCharactersTable> {
  $$LocalCharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionCharacter => $composableBuilder(
    column: $table.descriptionCharacter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imgUrl => $composableBuilder(
    column: $table.imgUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCharactersTableOrderingComposer
    extends Composer<_$LocalNameDatabase, $LocalCharactersTable> {
  $$LocalCharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionCharacter => $composableBuilder(
    column: $table.descriptionCharacter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imgUrl => $composableBuilder(
    column: $table.imgUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCharactersTableAnnotationComposer
    extends Composer<_$LocalNameDatabase, $LocalCharactersTable> {
  $$LocalCharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get descriptionCharacter => $composableBuilder(
    column: $table.descriptionCharacter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get imgUrl =>
      $composableBuilder(column: $table.imgUrl, builder: (column) => column);

  GeneratedColumn<int> get sort =>
      $composableBuilder(column: $table.sort, builder: (column) => column);
}

class $$LocalCharactersTableTableManager
    extends
        RootTableManager<
          _$LocalNameDatabase,
          $LocalCharactersTable,
          LocalCharacter,
          $$LocalCharactersTableFilterComposer,
          $$LocalCharactersTableOrderingComposer,
          $$LocalCharactersTableAnnotationComposer,
          $$LocalCharactersTableCreateCompanionBuilder,
          $$LocalCharactersTableUpdateCompanionBuilder,
          (
            LocalCharacter,
            BaseReferences<
              _$LocalNameDatabase,
              $LocalCharactersTable,
              LocalCharacter
            >,
          ),
          LocalCharacter,
          PrefetchHooks Function()
        > {
  $$LocalCharactersTableTableManager(
    _$LocalNameDatabase db,
    $LocalCharactersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> descriptionCharacter = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> imgUrl = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalCharactersCompanion(
                id: id,
                nameId: nameId,
                name: name,
                descriptionCharacter: descriptionCharacter,
                url: url,
                imgUrl: imgUrl,
                sort: sort,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameId,
                required String name,
                Value<String?> descriptionCharacter = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> imgUrl = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalCharactersCompanion.insert(
                id: id,
                nameId: nameId,
                name: name,
                descriptionCharacter: descriptionCharacter,
                url: url,
                imgUrl: imgUrl,
                sort: sort,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalNameDatabase,
      $LocalCharactersTable,
      LocalCharacter,
      $$LocalCharactersTableFilterComposer,
      $$LocalCharactersTableOrderingComposer,
      $$LocalCharactersTableAnnotationComposer,
      $$LocalCharactersTableCreateCompanionBuilder,
      $$LocalCharactersTableUpdateCompanionBuilder,
      (
        LocalCharacter,
        BaseReferences<
          _$LocalNameDatabase,
          $LocalCharactersTable,
          LocalCharacter
        >,
      ),
      LocalCharacter,
      PrefetchHooks Function()
    >;
typedef $$LocalSongsTableCreateCompanionBuilder =
    LocalSongsCompanion Function({
      Value<int> id,
      required String nameId,
      required String title,
      Value<String?> singer,
      Value<String?> url,
      Value<int> sort,
    });
typedef $$LocalSongsTableUpdateCompanionBuilder =
    LocalSongsCompanion Function({
      Value<int> id,
      Value<String> nameId,
      Value<String> title,
      Value<String?> singer,
      Value<String?> url,
      Value<int> sort,
    });

class $$LocalSongsTableFilterComposer
    extends Composer<_$LocalNameDatabase, $LocalSongsTable> {
  $$LocalSongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get singer => $composableBuilder(
    column: $table.singer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSongsTableOrderingComposer
    extends Composer<_$LocalNameDatabase, $LocalSongsTable> {
  $$LocalSongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get singer => $composableBuilder(
    column: $table.singer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSongsTableAnnotationComposer
    extends Composer<_$LocalNameDatabase, $LocalSongsTable> {
  $$LocalSongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get singer =>
      $composableBuilder(column: $table.singer, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<int> get sort =>
      $composableBuilder(column: $table.sort, builder: (column) => column);
}

class $$LocalSongsTableTableManager
    extends
        RootTableManager<
          _$LocalNameDatabase,
          $LocalSongsTable,
          LocalSong,
          $$LocalSongsTableFilterComposer,
          $$LocalSongsTableOrderingComposer,
          $$LocalSongsTableAnnotationComposer,
          $$LocalSongsTableCreateCompanionBuilder,
          $$LocalSongsTableUpdateCompanionBuilder,
          (
            LocalSong,
            BaseReferences<_$LocalNameDatabase, $LocalSongsTable, LocalSong>,
          ),
          LocalSong,
          PrefetchHooks Function()
        > {
  $$LocalSongsTableTableManager(_$LocalNameDatabase db, $LocalSongsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> singer = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalSongsCompanion(
                id: id,
                nameId: nameId,
                title: title,
                singer: singer,
                url: url,
                sort: sort,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameId,
                required String title,
                Value<String?> singer = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalSongsCompanion.insert(
                id: id,
                nameId: nameId,
                title: title,
                singer: singer,
                url: url,
                sort: sort,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSongsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalNameDatabase,
      $LocalSongsTable,
      LocalSong,
      $$LocalSongsTableFilterComposer,
      $$LocalSongsTableOrderingComposer,
      $$LocalSongsTableAnnotationComposer,
      $$LocalSongsTableCreateCompanionBuilder,
      $$LocalSongsTableUpdateCompanionBuilder,
      (
        LocalSong,
        BaseReferences<_$LocalNameDatabase, $LocalSongsTable, LocalSong>,
      ),
      LocalSong,
      PrefetchHooks Function()
    >;
typedef $$LocalChildrenTableCreateCompanionBuilder =
    LocalChildrenCompanion Function({
      Value<int> id,
      required String nameId,
      required String name,
      Value<String?> parents,
      Value<int> birthday,
      Value<int> death,
      Value<int> sort,
    });
typedef $$LocalChildrenTableUpdateCompanionBuilder =
    LocalChildrenCompanion Function({
      Value<int> id,
      Value<String> nameId,
      Value<String> name,
      Value<String?> parents,
      Value<int> birthday,
      Value<int> death,
      Value<int> sort,
    });

class $$LocalChildrenTableFilterComposer
    extends Composer<_$LocalNameDatabase, $LocalChildrenTable> {
  $$LocalChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parents => $composableBuilder(
    column: $table.parents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get death => $composableBuilder(
    column: $table.death,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalChildrenTableOrderingComposer
    extends Composer<_$LocalNameDatabase, $LocalChildrenTable> {
  $$LocalChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameId => $composableBuilder(
    column: $table.nameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parents => $composableBuilder(
    column: $table.parents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get death => $composableBuilder(
    column: $table.death,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sort => $composableBuilder(
    column: $table.sort,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalChildrenTableAnnotationComposer
    extends Composer<_$LocalNameDatabase, $LocalChildrenTable> {
  $$LocalChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameId =>
      $composableBuilder(column: $table.nameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parents =>
      $composableBuilder(column: $table.parents, builder: (column) => column);

  GeneratedColumn<int> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<int> get death =>
      $composableBuilder(column: $table.death, builder: (column) => column);

  GeneratedColumn<int> get sort =>
      $composableBuilder(column: $table.sort, builder: (column) => column);
}

class $$LocalChildrenTableTableManager
    extends
        RootTableManager<
          _$LocalNameDatabase,
          $LocalChildrenTable,
          LocalChildrenData,
          $$LocalChildrenTableFilterComposer,
          $$LocalChildrenTableOrderingComposer,
          $$LocalChildrenTableAnnotationComposer,
          $$LocalChildrenTableCreateCompanionBuilder,
          $$LocalChildrenTableUpdateCompanionBuilder,
          (
            LocalChildrenData,
            BaseReferences<
              _$LocalNameDatabase,
              $LocalChildrenTable,
              LocalChildrenData
            >,
          ),
          LocalChildrenData,
          PrefetchHooks Function()
        > {
  $$LocalChildrenTableTableManager(
    _$LocalNameDatabase db,
    $LocalChildrenTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parents = const Value.absent(),
                Value<int> birthday = const Value.absent(),
                Value<int> death = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalChildrenCompanion(
                id: id,
                nameId: nameId,
                name: name,
                parents: parents,
                birthday: birthday,
                death: death,
                sort: sort,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameId,
                required String name,
                Value<String?> parents = const Value.absent(),
                Value<int> birthday = const Value.absent(),
                Value<int> death = const Value.absent(),
                Value<int> sort = const Value.absent(),
              }) => LocalChildrenCompanion.insert(
                id: id,
                nameId: nameId,
                name: name,
                parents: parents,
                birthday: birthday,
                death: death,
                sort: sort,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalChildrenTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalNameDatabase,
      $LocalChildrenTable,
      LocalChildrenData,
      $$LocalChildrenTableFilterComposer,
      $$LocalChildrenTableOrderingComposer,
      $$LocalChildrenTableAnnotationComposer,
      $$LocalChildrenTableCreateCompanionBuilder,
      $$LocalChildrenTableUpdateCompanionBuilder,
      (
        LocalChildrenData,
        BaseReferences<
          _$LocalNameDatabase,
          $LocalChildrenTable,
          LocalChildrenData
        >,
      ),
      LocalChildrenData,
      PrefetchHooks Function()
    >;

class $LocalNameDatabaseManager {
  final _$LocalNameDatabase _db;
  $LocalNameDatabaseManager(this._db);
  $$LocalNamesTableTableManager get localNames =>
      $$LocalNamesTableTableManager(_db, _db.localNames);
  $$LocalCelebritiesTableTableManager get localCelebrities =>
      $$LocalCelebritiesTableTableManager(_db, _db.localCelebrities);
  $$LocalCharactersTableTableManager get localCharacters =>
      $$LocalCharactersTableTableManager(_db, _db.localCharacters);
  $$LocalSongsTableTableManager get localSongs =>
      $$LocalSongsTableTableManager(_db, _db.localSongs);
  $$LocalChildrenTableTableManager get localChildren =>
      $$LocalChildrenTableTableManager(_db, _db.localChildren);
}
