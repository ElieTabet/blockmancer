import 'package:assets/assets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('assets package key and logo image resolve', () {
    expect(Assets.package, 'assets');
    expect(Assets.images.logo.path, isNotEmpty);
  });
}
