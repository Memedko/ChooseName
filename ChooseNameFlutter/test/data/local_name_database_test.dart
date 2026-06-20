import 'package:choose_name/data/services/local_name_database.dart';
import 'package:choose_name/domain/models/gender_type.dart';
import 'package:choose_name/domain/models/name_decision.dart';
import 'package:choose_name/domain/models/name_record.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalNameDatabase database;

  setUp(() {
    database = LocalNameDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('stores names and applies like/dislike state transitions', () async {
    await database.upsertName(
      GenderType.male,
      const NameRecord(nameId: 'andrii', name: 'Андрій'),
    );

    expect(await database.getUnseenNames(GenderType.male), hasLength(1));

    await database.setDecision(GenderType.male, 'andrii', NameDecision.liked);

    expect(await database.getUnseenNames(GenderType.male), isEmpty);
    expect(await database.getLikedNames(GenderType.male), hasLength(1));

    await database.setDecision(
      GenderType.male,
      'andrii',
      NameDecision.disliked,
    );
    await database.resetDislikedNames(GenderType.male);

    expect(await database.getUnseenNames(GenderType.male), hasLength(1));
  });

  test('adds custom liked names without name id', () async {
    await database.addCustomLikedName(GenderType.female, 'Лея');

    final liked = await database.getLikedNames(GenderType.female);

    expect(liked.single.name, 'Лея');
    expect(liked.single.nameId, isNull);
  });
}
