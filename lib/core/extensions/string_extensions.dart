extension StringExtensions on String {
  /// Converts snake_case or kebab-case to Title Case
  ///
  /// e.g. "value_error" -> "Value Error"
  String get normalize {
    if (isEmpty) return this;
    // Split by snake_case or kebab-case
    final words = split(RegExp('(_|-)'));

    // Capitalize first letter of each word and join with spaces
    return words
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
