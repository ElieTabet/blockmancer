import 'package:blockmancer_engine/src/random/mulberry32.dart';
import 'package:test/test.dart';

// Expected values come from the reference prototype's rand() and Math.imul run
// in Node. This suite runs on the VM and in Chrome (`melos run test-engine-web`):
// both must produce them exactly.
void main() {
  group('imul32', () {
    test('wraps like Math.imul on overflowing products', () {
      // Given / When / Then
      expect(imul32(0xFFFFFFFF, 5), 4294967291);
      expect(imul32(0x7FFFFFFF, 0x7FFFFFFF), 1);
      expect(imul32(0x12345678, 0x9ABCDEF0), 606937216);
    });
  });

  group('Mulberry32', () {
    test('the daily seed draws the same numbers as the prototype', () {
      // Given
      var rng = const Mulberry32(20261016);
      final values = <double>[];

      // When
      for (var i = 0; i < 5; i++) {
        final (value, next) = rng.next();
        values.add(value);
        rng = next;
      }

      // Then
      expect(values, [
        0.18689791089855134,
        0.5267679621465504,
        0.036956520518288016,
        0.19033258804120123,
        0.27266927040182054,
      ]);
    });

    test('drawing does not change the generator it was drawn from', () {
      // Given
      const rng = Mulberry32(7);

      // When
      final (first, _) = rng.next();
      final (again, _) = rng.next();

      // Then
      expect(again, first);
    });

    test('an int draw stays within its bound', () {
      // Given
      var rng = const Mulberry32(1);

      // When / Then
      for (var i = 0; i < 1000; i++) {
        final (value, next) = rng.nextInt(64);
        expect(value, inInclusiveRange(0, 63));
        rng = next;
      }
    });
  });
}
