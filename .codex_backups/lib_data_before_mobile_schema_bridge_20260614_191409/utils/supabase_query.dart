String supabaseContainsPattern(String value) {
  final sanitized = value
      .trim()
      .replaceAll('\\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_')
      .replaceAll(',', r'\,')
      .replaceAll(')', r'\)')
      .replaceAll('(', r'\(');
  return '%$sanitized%';
}
