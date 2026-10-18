import 'package:in_app_review/in_app_review.dart';
import 'package:store_review/src/package_name.dart';
import 'package:timber/timber.dart';

/// The stores' own rating prompt (StoreKit on iOS, Play In-App Review on
/// Android) and the app's store page.
abstract interface class StoreReview {
  /// Opens the app's page in its store: always allowed, for Settings' Rate
  /// row. Never throws.
  Future<void> openStoreListing();

  /// Asks the OS to show its rating prompt; the OS decides whether it does
  /// (Apple at most three times a year). Never throws.
  Future<void> requestReview();
}

/// [StoreReview] over `in_app_review`. [appStoreId] is the app's Apple ID,
/// which iOS needs for the store page.
final class InAppStoreReview implements StoreReview {
  InAppStoreReview({required String appStoreId, InAppReview? review})
    : _appStoreId = appStoreId,
      _injected = review;

  final String _appStoreId;
  final InAppReview? _injected;

  InAppReview get _review => _injected ?? InAppReview.instance;

  @override
  Future<void> openStoreListing() async {
    try {
      await _review.openStoreListing(appStoreId: _appStoreId);
    } catch (error, stackTrace) {
      _log('Opening the store page failed', error, stackTrace);
    }
  }

  @override
  Future<void> requestReview() async {
    try {
      if (await _review.isAvailable()) await _review.requestReview();
    } catch (error, stackTrace) {
      _log('Asking for a review failed', error, stackTrace);
    }
  }

  static void _log(String message, Object error, StackTrace stackTrace) =>
      Timber.e(
        tag: packageName,
        logMessage: message,
        exception: error,
        stackTrace: stackTrace,
      );
}
