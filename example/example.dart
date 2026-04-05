// SPDX-FileCopyrightText: © 2026 Anthony Champagne <dev@anthonychampagne.fr>
//
// SPDX-License-Identifier: BSD-3-Clause

// ignore_for_file: avoid_print

import 'package:ac_posix_locale/ac_posix_locale.dart';

void main() {
  _parseExample();
  _buildExample();
}

void _parseExample() {
  print('--- Parsing POSIX locale strings ---');

  final plain = PosixLocaleLang.parse('en');
  print('language: ${plain.language}'); // en

  final withTerritory = PosixLocaleLang.parse('en_US');
  print('language:  ${withTerritory.language}'); // en
  print('territory: ${withTerritory.territory}'); // US

  final full = PosixLocaleLang.parse('fr_FR.UTF-8');
  print('language:  ${full.language}'); // fr
  print('territory: ${full.territory}'); // FR
  print('codeset:   ${full.codeset}'); // UTF-8

  final withModifier = PosixLocaleLang.parse('sr_RS.UTF-8@latin');
  print('language:  ${withModifier.language}'); // sr
  print('territory: ${withModifier.territory}'); // RS
  print('codeset:   ${withModifier.codeset}'); // UTF-8
  print(
    'modifiers: ${withModifier.modifiers.map((e) => '${e.key}=${e.value}').toList()}',
  ); // [latin=]

  final minimal = PosixLocaleLang.parse('C');
  print('minimal:   ${minimal.language}'); // C
  print('is minimal locale: ${minimal.minimalLocale}'); // true
}

void _buildExample() {
  print('\n--- Building locale objects ---');

  final locale = PosixLocaleLang(
    language: 'de',
    territory: 'DE',
    codeset: 'UTF-8',
  );
  print('$locale'); // de_DE.UTF-8
}
