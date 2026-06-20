enum GenderType {
  male,
  female;

  bool get isMale => this == GenderType.male;

  String get storageValue => switch (this) {
    GenderType.male => 'male',
    GenderType.female => 'female',
  };

  static GenderType fromStorageValue(String value) {
    return value == GenderType.female.storageValue
        ? GenderType.female
        : GenderType.male;
  }
}
