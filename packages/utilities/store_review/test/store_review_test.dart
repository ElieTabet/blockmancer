import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mocktail/mocktail.dart';
import 'package:store_review/store_review.dart';

class _MockReview extends Mock implements InAppReview {}

void main() {
  late _MockReview review;

  setUp(() => review = _MockReview());

  test('Given a platform without the prompt, When a review is asked for, Then '
      'nothing is shown and nothing throws', () async {
    // Given
    when(() => review.isAvailable()).thenAnswer((_) async => false);

    // When
    await InAppStoreReview(appStoreId: '1', review: review).requestReview();

    // Then
    verifyNever(() => review.requestReview());
  });

  test('Given the store page, When it is opened, Then it names the app\'s '
      'Apple ID, and a failure doesn\'t throw', () async {
    // Given
    when(
      () => review.openStoreListing(appStoreId: any(named: 'appStoreId')),
    ).thenThrow(Exception('no store'));

    // When
    await InAppStoreReview(
      appStoreId: '6740000000',
      review: review,
    ).openStoreListing();

    // Then
    verify(() => review.openStoreListing(appStoreId: '6740000000')).called(1);
  });
}
