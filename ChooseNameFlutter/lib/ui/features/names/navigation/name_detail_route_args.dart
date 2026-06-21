import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_record.dart';

class NameDetailRouteArgs {
  const NameDetailRouteArgs({required this.name, required this.gender});

  final NameRecord name;
  final GenderType gender;
}
