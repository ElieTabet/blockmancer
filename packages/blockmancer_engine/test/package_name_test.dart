import 'package:blockmancer_engine/src/package_name.dart';
import 'package:test/test.dart';

void main() {
  test('the package knows its own name', () {
    // Given / When / Then
    expect(packageName, 'blockmancer_engine');
  });
}
