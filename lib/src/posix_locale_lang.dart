// SPDX-FileCopyrightText: © 2023 - 2026 Anthony Champagne <dev@anthonychampagne.fr>
//
// SPDX-License-Identifier: BSD-3-Clause

// ignore_for_file: avoid-substring

import 'package:ac_dart_essentials/ac_dart_essentials.dart';
import 'package:meta/meta.dart';

/// POSIX Locale LANG Environment Variable (IEEE Std 1003.1)
/// https://pubs.opengroup.org/onlinepubs/9699919799/
@immutable
class PosixLocaleLang {
  static const kIso639_1CodeLength = 2;
  static const kIso3166_1CodeLength = 2;

  /// Pattern for POSIX codeset identifiers (case-insensitive, e.g. UTF-8, ISO8859-1).
  static const kCodesetPattern = r'[a-z0-9_\-]+';

  /// Minimal locale identifiers that are not ISO 639-1 language codes.
  static const kMinimalLocaleIdentifiers = ['POSIX', 'C'];

  /// ISO 639-1 2-character language codes, or a minimal locale identifier
  /// (`'C'` or `'POSIX'`). Use [minimalLocale] to distinguish the two cases.
  final String language;

  /// ISO 3166-1 2-character country codes.
  final String? territory;

  /// For example, IEC 8859 parts 1 to 16 are usually specified as ISO8859-1 and so on.
  /// should be taken from the values in the IANA character sets list.
  final String? codeset;

  /// a list of identifiers, or name-value pairs.
  /// Sometimes this is used to indicate the language script in use, as such values from ISO 15924 should be used.
  final Iterable<MapEntry<String, String>> modifiers;

  PosixLocaleLang({
    required this.language,
    this.territory,
    this.codeset,
    this.modifiers = const [],
  }) {
    // Minimal locale identifiers ('C', 'POSIX') are valid; regular language
    // codes must be exactly kIso639_1CodeLength characters.
    if (!kMinimalLocaleIdentifiers.contains(language) &&
        language.length != kIso639_1CodeLength) {
      throw ArgumentError.value(language, 'language');
    }
    if (territory != null && territory!.length != kIso3166_1CodeLength) {
      throw ArgumentError.value(territory, 'territory');
    }
    if (codeset != null && !kCodesetPattern.entireMatchI(codeset!)) {
      throw ArgumentError.value(codeset, 'codeset');
    }
  }

  /// From [language[_territory][.codeset][@modifier]]
  factory PosixLocaleLang.parse(String posixLocale) {
    int? territoryIndex = posixLocale.indexOf('_');
    int? codesetIndex = posixLocale.indexOf('.', territoryIndex + 1);
    int? modifierIndex = posixLocale.indexOf('@', codesetIndex + 1);

    territoryIndex = territoryIndex == -1 ? null : territoryIndex;
    codesetIndex = codesetIndex == -1 ? null : codesetIndex;
    modifierIndex = modifierIndex == -1 ? null : modifierIndex;

    final language = posixLocale.substring(
      0,
      territoryIndex ?? codesetIndex ?? modifierIndex,
    );

    String? territory;
    String? codeset;
    Iterable<MapEntry<String, String>>? modifiers;

    if (territoryIndex != null) {
      territory = posixLocale.substring(
        territoryIndex + 1,
        codesetIndex ?? modifierIndex,
      );
    }
    if (codesetIndex != null) {
      codeset = posixLocale.substring(codesetIndex + 1, modifierIndex);
    }
    if (modifierIndex != null) {
      final modifier = posixLocale.substring(modifierIndex + 1);

      modifiers = modifier.split(';').map((element) {
        final keyValue = element.split('=');

        return MapEntry(
          keyValue.first,
          keyValue.length > 1 ? keyValue.sublist(1).join('=') : '',
        );
      });
    }

    return PosixLocaleLang(
      language: language,
      territory: territory,
      codeset: codeset,
      modifiers: modifiers ?? const [],
    );
  }

  /// Returns `true` if [language] is a minimal locale identifier (`'C'` or `'POSIX'`).
  bool get minimalLocale => kMinimalLocaleIdentifiers.contains(language);

  /// Returns a copy of this instance with the given fields replaced.
  PosixLocaleLang copyWith({
    String? language,
    Object? territory = _undefinedSentinel,
    Object? codeset = _undefinedSentinel,
    Iterable<MapEntry<String, String>>? modifiers,
  }) =>
      PosixLocaleLang(
        language: language ?? this.language,
        territory: territory == _undefinedSentinel
            ? this.territory
            : territory as String?,
        codeset:
            codeset == _undefinedSentinel ? this.codeset : codeset as String?,
        modifiers: modifiers ?? this.modifiers,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PosixLocaleLang &&
          runtimeType == other.runtimeType &&
          language == other.language &&
          territory == other.territory &&
          codeset == other.codeset &&
          _modifierMapEquals(modifiers, other.modifiers);

  @override
  int get hashCode => Object.hash(
        language,
        territory,
        codeset,
        Object.hashAll(modifiers.map((e) => Object.hash(e.key, e.value))),
      );

  @override
  String toString() {
    String locale = language;
    if (territory != null) {
      locale += '_$territory';
    }
    if (codeset != null) {
      locale += '.$codeset';
    }
    if (modifiers.isNotEmpty) {
      locale += '@';
      locale += modifiers
          .map(
            (modifier) =>
                '${modifier.key}${modifier.value.isEmpty ? '' : '=${modifier.value}'}',
          )
          .join(';');
    }

    return locale;
  }
}

// Sentinel object for copyWith nullable parameters.
const _undefinedSentinel = Object();

bool _modifierMapEquals(
  Iterable<MapEntry<String, String>> a,
  Iterable<MapEntry<String, String>> b,
) {
  final listA = a.toList();
  final listB = b.toList();
  if (listA.length != listB.length) return false;
  for (var i = 0; i < listA.length; i++) {
    if (listA[i].key != listB[i].key || listA[i].value != listB[i].value) {
      return false;
    }
  }
  return true;
}
