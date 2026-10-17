// Fails on a quoted literal with a letter in it used as user-facing text, so
// every string a player reads goes through slang (`context.t`). Run through
// scripts/check_hardcoded_strings.sh; see that file for the rules.
import 'dart:io';

// A literal right after one of these is copy: `Text('…')`, `SelectableText('…')`,
// `TextSpan(text: '…')` and the named arguments widgets read out or show.
final _copySite = RegExp(
  r'(?:\b(?:Selectable)?Text\(\s*|\b(?:hintText|label|labelText|message|'
  r'semanticLabel|semanticsLabel|text|title|tooltip)\s*:\s*)'
  r"""r?(?<literal>'(?:[^'\\\n]|\\.)*'|"(?:[^"\\\n]|\\.)*")""",
);

final _escape = RegExp(r'//\s*l10n-ignore:\s*\S');

// Interpolations and escapes are code, not copy: '$count' or '\u00A0' is fine.
final _notCopy = RegExp(r'\\u\{[0-9a-fA-F]+\}|\\.|\$\{[^}]*\}|\$\w+');

final _letter = RegExp(r'\p{L}', unicode: true);

final _generated = RegExp(r'\.(g|gr|freezed|gen|config|mocks)\.dart$');

void main(List<String> arguments) {
  final root = File.fromUri(Platform.script).parent.parent.path;
  final files = arguments.isEmpty
      ? _defaultFiles(root)
      : arguments.expand(_dartFilesUnder).toList();
  final hits = <String>[];

  for (final file in files..sort((a, b) => a.path.compareTo(b.path))) {
    hits.addAll(_hitsIn(file, root));
  }

  if (hits.isEmpty) {
    stdout.writeln('No hard-coded user-facing strings.');
    return;
  }

  stderr
    ..writeln('Hard-coded user-facing strings — move them to slang')
    ..writeln('(packages/dsm/l10n/application/lib/i18n/*.i18n.json) and read')
    ..writeln('them with context.t, or mark genuine non-copy with')
    ..writeln('`// l10n-ignore: <reason>` on the same line:')
    ..writeln()
    ..writeAll(hits, '\n')
    ..writeln();
  exitCode = 1;
}

List<File> _defaultFiles(String root) {
  final presentation = RegExp(r'^packages/(.+/)?presentation/lib/');
  final composition = RegExp(r'^packages/composition/[^/]+/lib/');
  final app = RegExp(r'^app/lib/');

  return _dartFilesUnder(
    '$root/packages',
  ).followedBy(_dartFilesUnder('$root/app/lib')).where((file) {
    final path = _relative(file.path, root);

    return presentation.hasMatch(path) ||
        composition.hasMatch(path) ||
        app.hasMatch(path);
  }).toList();
}

Iterable<File> _dartFilesUnder(String path) {
  if (FileSystemEntity.isFileSync(path)) return [File(path)];

  final directory = Directory(path);

  if (!directory.existsSync()) return const [];

  return directory
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((file) {
        final path = file.path;

        return path.endsWith('.dart') &&
            !_generated.hasMatch(path) &&
            !path.contains('/.dart_tool/') &&
            !path.contains('/build/') &&
            !path.contains('/test/');
      });
}

Iterable<String> _hitsIn(File file, String root) sync* {
  final source = file.readAsStringSync();
  final lines = source.split('\n');

  for (final match in _copySite.allMatches(source)) {
    final literal = match.namedGroup('literal')!;
    final copy = literal
        .substring(1, literal.length - 1)
        .replaceAll(_notCopy, '');

    if (!_letter.hasMatch(copy)) continue;

    final startLine = _lineOf(match.start, source);
    final literalLine = _lineOf(match.end - 1, source);
    final start = lines[startLine];
    final beforeMatch = start.substring(
      0,
      match.start - _offsetOf(startLine, lines),
    );
    final trimmed = start.trimLeft();

    if (beforeMatch.contains('//') ||
        trimmed.startsWith('*') ||
        trimmed.startsWith('/*')) {
      continue;
    }

    if (_escape.hasMatch(start) || _escape.hasMatch(lines[literalLine])) {
      continue;
    }

    yield '${_relative(file.path, root)}:${literalLine + 1}: ${lines[literalLine].trim()}';
  }
}

int _lineOf(int offset, String source) =>
    '\n'.allMatches(source.substring(0, offset)).length;

int _offsetOf(int line, List<String> lines) =>
    lines.take(line).fold(0, (offset, text) => offset + text.length + 1);

String _relative(String path, String root) =>
    path.startsWith('$root/') ? path.substring(root.length + 1) : path;
