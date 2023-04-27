// ignore_for_file: avoid-substring

import 'package:anthochamp_dart_essentials/dart_essentials.dart';

/// POSIX Locale LANG Environment Variable (IEEE Std 1003.1)
/// https://pubs.opengroup.org/onlinepubs/9699919799/
class PosixLocaleLang {
  static const kIso639_1CodeLength = 2;
  static const kIso3166_1CodeLength = 2;
  static const kCodesetPattern = r'[a-z0-9_\-]+';
  static const kMinimalLocaleIdentifiers = ['POSIX', 'C'];

  /// ISO 639-1 2-character language codes
  /// or it may be a minimal locale identifier
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
    if (language.length != kIso639_1CodeLength ||
        kMinimalLocaleIdentifiers.contains(language)) {
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

        return MapEntry(keyValue.first, keyValue.last);
      });
    }

    return PosixLocaleLang(
      language: language,
      territory: territory,
      codeset: codeset,
      modifiers: modifiers ?? const [],
    );
  }

  bool isMinimalLocale() => kMinimalLocaleIdentifiers.contains(language);

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
          .map((modifier) =>
              '${modifier.key}${modifier.value.isEmpty ? '' : '=${modifier.value}'}')
          .join(';');
    }

    return locale;
  }
}
