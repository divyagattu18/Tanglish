/// Input validation helpers used at system boundaries.
/// Never call these for data that has already been validated/sanitized.
class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    if (trimmed.length > 254) {
      return 'Email is too long';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length > 50) {
      return 'Name must be 50 characters or less';
    }
    // Block HTML/script-injection characters
    if (RegExp("[<>&\"'`]").hasMatch(trimmed)) {
      return 'Name contains invalid characters';
    }
    return null;
  }

  /// Strips dangerous characters and trims to [maxLength].
  static String sanitize(String input, {int maxLength = 100}) {
    final trimmed = input.trim();
    final clean = trimmed.replaceAll(RegExp("[<>&\"'`]"), '');
    return clean.length > maxLength ? clean.substring(0, maxLength) : clean;
  }
}
