import 'package:choose_name/domain/models/gender_type.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:choose_name/domain/use_cases/build_name_detail_sections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds the same conditional sections as the iOS detail screen', () {
    final sections = BuildNameDetailSections()(
      name: const NameRecord(
        name: 'Марко',
        description: 'Значення',
        versions: 'Марк',
        transliteration: 'Marko',
        days: '8 травня',
      ),
      gender: GenderType.male,
      lastName: 'Шевченко',
      fatherName: 'Іванович',
    );

    expect(
      sections.map((section) => section.type),
      containsAllInOrder([
        NameDetailSectionType.name,
        NameDetailSectionType.fullName,
        NameDetailSectionType.initials,
        NameDetailSectionType.description,
        NameDetailSectionType.versions,
        NameDetailSectionType.transliteration,
        NameDetailSectionType.days,
      ]),
    );
  });
}
