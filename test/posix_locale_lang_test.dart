import 'package:test/test.dart';

import 'package:ac_posix_locale/src/posix_locale_lang.dart';

void main() {
  test('parse', () {
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
}
