// SPDX-FileCopyrightText: © 2023 - 2026 Anthony Champagne <dev@anthonychampagne.fr>
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';

import 'package:ac_posix_locale/src/posix_locale_lang.dart';

void main() {
  group('PosixLocaleLang.parse', () {
    test('parses full locale string', () {
      final lang = PosixLocaleLang.parse('en_US.UTF-8@mod1=val1;mod2');
      expect(lang.language, equals('en'));
      expect(lang.territory, equals('US'));
      expect(lang.codeset, equals('UTF-8'));
      expect(lang.modifiers.length, equals(2));
      expect(lang.modifiers.first.key, equals('mod1'));
      expect(lang.modifiers.first.value, equals('val1'));
      expect(lang.modifiers.elementAt(1).key, equals('mod2'));
      expect(lang.modifiers.elementAt(1).value, equals(''));
    });

    test('parses language-only locale', () {
      final lang = PosixLocaleLang.parse('fr');
      expect(lang.language, equals('fr'));
      expect(lang.territory, isNull);
      expect(lang.codeset, isNull);
      expect(lang.modifiers, isEmpty);
    });

    test('parses POSIX minimal locale', () {
      final lang = PosixLocaleLang.parse('C');
      expect(lang.language, equals('C'));
      expect(lang.minimalLocale, isTrue);
    });

    test('parses POSIX minimal locale (POSIX)', () {
      final lang = PosixLocaleLang.parse('POSIX');
      expect(lang.language, equals('POSIX'));
      expect(lang.minimalLocale, isTrue);
    });

    test('parses uppercase codeset (e.g. ISO8859-1)', () {
      final lang = PosixLocaleLang.parse('de_DE.ISO8859-1');
      expect(lang.codeset, equals('ISO8859-1'));
    });

    test('round-trip toString', () {
      const locales = ['en_US.UTF-8', 'fr_FR', 'C', 'POSIX', 'de_DE.ISO8859-1'];
      for (final locale in locales) {
        expect(PosixLocaleLang.parse(locale).toString(), equals(locale));
      }
    });
  });

  group('PosixLocaleLang constructor', () {
    test('accepts regular language code', () {
      final lang = PosixLocaleLang(language: 'en', territory: 'US');
      expect(lang.minimalLocale, isFalse);
    });

    test('accepts minimal locale identifiers C and POSIX', () {
      expect(PosixLocaleLang(language: 'C').minimalLocale, isTrue);
      expect(PosixLocaleLang(language: 'POSIX').minimalLocale, isTrue);
    });

    test('throws ArgumentError for invalid language length', () {
      expect(
        () => PosixLocaleLang(language: 'eng'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError for invalid codeset', () {
      expect(
        () => PosixLocaleLang(language: 'en', codeset: 'invalid codeset!'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('PosixLocaleLang equality', () {
    test('equal instances compare equal', () {
      final a = PosixLocaleLang.parse('en_US.UTF-8');
      final b = PosixLocaleLang.parse('en_US.UTF-8');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different instances compare unequal', () {
      final a = PosixLocaleLang.parse('en_US.UTF-8');
      final b = PosixLocaleLang.parse('fr_FR.UTF-8');
      expect(a, isNot(equals(b)));
    });
  });

  group('PosixLocaleLang.copyWith', () {
    test('copies with updated language', () {
      final original = PosixLocaleLang.parse('en_US.UTF-8');
      final copy = original.copyWith(language: 'fr');
      expect(copy.language, equals('fr'));
      expect(copy.territory, equals('US'));
      expect(copy.codeset, equals('UTF-8'));
    });

    test('copies with cleared territory', () {
      final original = PosixLocaleLang.parse('en_US.UTF-8');
      // ignore: avoid_redundant_argument_values
      final copy = original.copyWith(territory: null);
      expect(copy.territory, isNull);
      expect(copy.language, equals('en'));
    });
  });
}
