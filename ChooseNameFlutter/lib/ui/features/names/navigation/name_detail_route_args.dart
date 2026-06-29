import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_record.dart';

class NameDetailRouteArgs {
  const NameDetailRouteArgs({
    required this.name,
    required this.gender,
    this.returnDecisionToCaller = false,
  });

  final NameRecord name;
  final GenderType gender;
  final bool returnDecisionToCaller;
}
