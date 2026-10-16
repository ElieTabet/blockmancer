import 'package:webviews_domain/src/entities/commands/raw_javascript.dart';

class StringToJavascriptArgumentConverter {
  const StringToJavascriptArgumentConverter();

  String call(Object? value) => switch (value) {
    null => 'null',
    final RawJavascript raw => raw.code,
    final bool b => b.toString(),
    final num n => n.toString(),
    final String s => "'${_escapeJs(s)}'",
    _ => "'${_escapeJs(value.toString())}'",
  };

  String _escapeJs(String value) => value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r')
      .replaceAll('\t', r'\t')
      .replaceAll('\x00', r'\0')
      .replaceAll('\u2028', r'\u2028')
      .replaceAll('\u2029', r'\u2029');
}
