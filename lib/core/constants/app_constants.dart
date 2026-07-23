class AppConstants {
  AppConstants._();

  // ── Firestore collections ─────────────────────────────────────────────
  static const String usersCollection = 'users';
  static const String lessonsCollection = 'lessons';
  static const String progressCollection = 'progress';

  // ── Categories ────────────────────────────────────────────────────────
  static const List<String> categories = [
    'Family',
    'School',
    'Playground',
    'Food',
    'Daily Activities',
  ];

  // ── XP ────────────────────────────────────────────────────────────────
  static const int xpPerLesson = 10;
  static const int streakBonusXp = 5;

  // ── Input limits ──────────────────────────────────────────────────────
  static const int maxInputLength = 100;
  static const int maxDisplayNameLength = 50;
  static const int maxEmailLength = 254;
}
