enum NameDecision {
  disliked(-1),
  neutral(0),
  liked(1);

  const NameDecision(this.value);

  final int value;

  static NameDecision fromValue(int value) {
    return switch (value) {
      -1 => NameDecision.disliked,
      1 => NameDecision.liked,
      _ => NameDecision.neutral,
    };
  }
}
