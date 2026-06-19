/// Small string helpers used across features.
extension StringNullX on String? {
  /// True when null, empty, or whitespace-only.
  bool get isNullOrBlank {
    final v = this;
    return v == null || v.trim().isEmpty;
  }

  /// True when there is at least one non-whitespace character.
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Returns `this` if non-blank, otherwise [fallback].
  String orElse(String fallback) => isNotNullOrBlank ? this! : fallback;
}
