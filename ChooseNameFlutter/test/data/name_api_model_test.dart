import 'package:choose_name/data/models/name_api_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses Firestore name payload into domain model', () {
    final model = NameApiModel.fromJson(<String, Object?>{
      'name': 'Марко',
      'versions': 'Марк, Марчик',
      'nameDays': '8 травня',
      'description': 'Значення імені',
      'transliteration': 'Marko',
      'celebrities': <Map<String, Object?>>[
        <String, Object?>{'name': 'Second', 'sort': 1},
        <String, Object?>{'name': 'First', 'sort': 10},
      ],
      'songs': <Map<String, Object?>>[
        <String, Object?>{'title': 'Song', 'singer': 'Singer'},
      ],
      'children': <Map<String, Object?>>[
        <String, Object?>{
          'name': 'Child',
          'parents': 'Parents',
          'birthday': 2001,
          'yearOfDeath': 0,
        },
      ],
      'sameNames': <String>['Марк', 'Маркіян'],
    }, nameId: 'marko');

    final domain = model.toDomain();

    expect(domain.nameId, 'marko');
    expect(domain.name, 'Марко');
    expect(domain.celebrities.first.name, 'First');
    expect(domain.songs.single.title, 'Song');
    expect(domain.children.single.birthday, 2001);
    expect(domain.sameNames, 'Марк\nМаркіян');
  });
}
