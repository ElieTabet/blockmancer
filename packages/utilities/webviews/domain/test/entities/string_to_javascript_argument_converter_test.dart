import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';

void main() {
  const converter = StringToJavascriptArgumentConverter();

  group('Turning a Dart value into a JavaScript argument', () {
    test(
      'Given a null value '
      'When it is converted '
      'Then it becomes the JavaScript null literal',
      () => expect(converter(null), 'null'),
    );

    test(
      'Given a true boolean '
      'When it is converted '
      'Then it becomes the JavaScript true literal',
      () => expect(converter(true), 'true'),
    );

    test(
      'Given a false boolean '
      'When it is converted '
      'Then it becomes the JavaScript false literal',
      () => expect(converter(false), 'false'),
    );

    test(
      'Given an integer '
      'When it is converted '
      'Then it becomes a numeric literal without quotes',
      () => expect(converter(42), '42'),
    );

    test(
      'Given a double '
      'When it is converted '
      'Then it becomes a numeric literal without quotes',
      () => expect(converter(3.14), '3.14'),
    );

    test(
      'Given a plain string '
      'When it is converted '
      'Then it becomes a single-quoted JavaScript string',
      () => expect(converter('hello'), "'hello'"),
    );

    test(
      'Given a non-primitive object '
      'When it is converted '
      'Then its toString is quoted as a JavaScript string',
      () => expect(
        converter(Uri.parse('https://example.com')),
        "'https://example.com'",
      ),
    );

    test(
      'Given a raw JavaScript expression '
      'When it is converted '
      'Then it is emitted verbatim, neither quoted nor escaped',
      () => expect(
        converter(const RawJavascript('{"token":"abc"}')),
        '{"token":"abc"}',
      ),
    );
  });

  group('Escaping a string so it cannot break out of its JavaScript literal', () {
    test(
      'Given a string containing a single quote '
      'When it is converted '
      'Then the quote is escaped',
      () => expect(converter("it's"), r"'it\'s'"),
    );

    test(
      'Given a string containing a backslash '
      'When it is converted '
      'Then the backslashes are escaped',
      () => expect(converter(r'path\to\file'), r"'path\\to\\file'"),
    );

    test(
      'Given a string containing newlines and carriage returns '
      'When it is converted '
      'Then the line terminators are escaped',
      () => expect(
        converter('line1\r\nline2\nline3'),
        r"'line1\r\nline2\nline3'",
      ),
    );

    test(
      'Given a string containing a tab '
      'When it is converted '
      'Then the tab is escaped',
      () => expect(converter('col1\tcol2'), r"'col1\tcol2'"),
    );

    test(
      'Given a string containing a null byte '
      'When it is converted '
      'Then the null byte is escaped',
      () => expect(converter('before\x00after'), r"'before\0after'"),
    );

    test(
      'Given a string containing Unicode line separators '
      'When it is converted '
      'Then the separators are escaped, so they cannot terminate the statement',
      () => expect(converter('a\u2028b\u2029c'), r"'a\u2028b\u2029c'"),
    );
  });
}
