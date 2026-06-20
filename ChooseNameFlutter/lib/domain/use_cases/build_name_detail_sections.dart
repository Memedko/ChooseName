import '../models/gender_type.dart';
import '../models/name_record.dart';

enum NameDetailSectionType {
  name,
  fullName,
  initials,
  description,
  versions,
  transliteration,
  englishVersion,
  langs,
  days,
  celebrities,
  characters,
  songs,
  children,
  sameNames,
}

class NameDetailSection {
  const NameDetailSection({required this.type, this.content});

  final NameDetailSectionType type;
  final Object? content;
}

class BuildNameDetailSections {
  List<NameDetailSection> call({
    required NameRecord name,
    required GenderType gender,
    required String lastName,
    required String fatherName,
  }) {
    final sections = <NameDetailSection>[
      NameDetailSection(type: NameDetailSectionType.name, content: name),
    ];
    if (lastName.isNotEmpty || fatherName.isNotEmpty) {
      sections.add(
        NameDetailSection(
          type: NameDetailSectionType.fullName,
          content:
              '${name.name} $fatherName ${lastName.isEmpty ? '' : lastName}'
                  .trim(),
        ),
      );
    }
    if (lastName.isNotEmpty && fatherName.isNotEmpty) {
      sections.add(
        NameDetailSection(
          type: NameDetailSectionType.initials,
          content: _initials(name.name, fatherName, lastName),
        ),
      );
    }
    _addText(sections, NameDetailSectionType.description, name.description);
    _addText(sections, NameDetailSectionType.versions, name.versions);
    if (name.transliteration?.isNotEmpty ?? false) {
      _addText(
        sections,
        NameDetailSectionType.transliteration,
        name.transliteration,
      );
    } else {
      _addText(sections, NameDetailSectionType.englishVersion, name.nameEng);
    }
    _addText(sections, NameDetailSectionType.langs, name.langs);
    _addText(sections, NameDetailSectionType.days, name.days);
    if (name.celebrities.isNotEmpty) {
      sections.add(
        NameDetailSection(
          type: NameDetailSectionType.celebrities,
          content: name.celebrities,
        ),
      );
    }
    if (name.characters.isNotEmpty) {
      sections.add(
        NameDetailSection(
          type: NameDetailSectionType.characters,
          content: name.characters,
        ),
      );
    }
    if (name.songs.isNotEmpty) {
      sections.add(
        NameDetailSection(
          type: NameDetailSectionType.songs,
          content: name.songs,
        ),
      );
    }
    if (name.children.isNotEmpty) {
      sections.add(
        NameDetailSection(
          type: NameDetailSectionType.children,
          content: name.children,
        ),
      );
    }
    _addText(sections, NameDetailSectionType.sameNames, name.sameNames);
    return sections;
  }

  void _addText(
    List<NameDetailSection> sections,
    NameDetailSectionType type,
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return;
    }
    sections.add(NameDetailSection(type: type, content: value));
  }

  String _initials(String name, String fatherName, String lastName) {
    final nameFirst = name.isEmpty ? 'A' : name.substring(0, 1);
    final fatherFirst = fatherName.isEmpty ? 'A' : fatherName.substring(0, 1);
    final lastFirst = lastName.isEmpty ? 'A' : lastName.substring(0, 1);
    return '$lastFirst$nameFirst$fatherFirst, '
        '$nameFirst$fatherFirst$lastFirst\n'
        '$nameFirst. $fatherFirst. $lastName, '
        '$lastName $nameFirst. $fatherFirst.';
  }
}
