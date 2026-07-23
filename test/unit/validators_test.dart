import 'package:flutter_test/flutter_test.dart';
import 'package:tanglish/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error for null input', () {
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
    });

    test('returns null for valid emails', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('test.user+tag@domain.co.uk'), isNull);
      expect(Validators.email('first.last@sub.domain.org'), isNull);
    });

    test('returns error for invalid email format', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('@nodomain.com'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
      expect(Validators.email('user@domain'), isNotNull);
    });

    test('returns error for email longer than 254 chars', () {
      final longEmail = '${'a' * 245}@b.com';
      expect(longEmail.length, greaterThan(254));
      expect(Validators.email(longEmail), isNotNull);
    });
  });

  group('Validators.displayName', () {
    test('returns error for null or empty', () {
      expect(Validators.displayName(null), isNotNull);
      expect(Validators.displayName(''), isNotNull);
      expect(Validators.displayName('  '), isNotNull);
    });

    test('returns null for valid names', () {
      expect(Validators.displayName('Arjun'), isNull);
      expect(Validators.displayName('Priya Sharma'), isNull);
      expect(Validators.displayName('A'), isNull);
    });

    test('returns error for name longer than 50 chars', () {
      expect(Validators.displayName('a' * 51), isNotNull);
    });

    test('returns null for name exactly 50 chars', () {
      expect(Validators.displayName('a' * 50), isNull);
    });

    test('returns error for HTML injection characters', () {
      expect(Validators.displayName('<script>'), isNotNull);
      expect(Validators.displayName('name"test'), isNotNull);
      expect(Validators.displayName("name'test"), isNotNull);
      expect(Validators.displayName('a&b'), isNotNull);
    });
  });

  group('Validators.sanitize', () {
    test('removes HTML injection characters', () {
      final result = Validators.sanitize('<script>alert("xss")</script>');
      expect(result.contains('<'), isFalse);
      expect(result.contains('>'), isFalse);
      expect(result.contains('"'), isFalse);
    });

    test('trims leading and trailing whitespace', () {
      expect(Validators.sanitize('  hello  '), equals('hello'));
    });

    test('truncates to maxLength', () {
      final input = 'a' * 200;
      final result = Validators.sanitize(input, maxLength: 100);
      expect(result.length, equals(100));
    });

    test('preserves safe characters', () {
      const safe = 'Priya Sharma 123';
      expect(Validators.sanitize(safe), equals(safe));
    });
  });
}
