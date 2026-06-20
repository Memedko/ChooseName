class Character {
  const Character({
    this.name = '',
    this.url,
    this.photo,
    this.description,
    this.sort = 0,
  });

  final String name;
  final String? url;
  final String? photo;
  final String? description;
  final int sort;
}
