class Child {
  const Child({
    this.name = '',
    this.parents,
    this.birthday = 0,
    this.yearOfDeath = 0,
    this.sort = 0,
  });

  final String name;
  final String? parents;
  final int birthday;
  final int yearOfDeath;
  final int sort;
}
