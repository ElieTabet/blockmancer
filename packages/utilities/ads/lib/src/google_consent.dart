import 'dart:async';

import 'package:ads/src/consent.dart';
import 'package:ads/src/package_name.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timber/timber.dart';

/// [Consent] over Google's UMP SDK. On iOS, the IDFA explainer set up in
/// AdMob's Privacy & messaging shows Apple's tracking alert itself once the
/// player continues; declining leaves ads non-personalised.
final class GoogleConsent implements Consent {
  /// [testDeviceIds] serve as the consent form's debug devices;
  /// [adTestDeviceIds] get AdMob's test ads even from a release build.
  GoogleConsent({
    List<String> adTestDeviceIds = const [],
    bool debugEea = false,
    List<String> testDeviceIds = const [],
  }) : _adTestDeviceIds = adTestDeviceIds,
       _debugEea = debugEea,
       _testDeviceIds = testDeviceIds;

  final List<String> _adTestDeviceIds;
  final _allowed = Completer<bool>();
  final bool _debugEea;
  var _started = false;
  final List<String> _testDeviceIds;

  @override
  Future<bool> adsAllowed() => _allowed.future;

  @override
  Future<ConsentOutcome> gather() async {
    try {
      await _updateConsentInfo();
      await _showFormIfRequired();

      final canRequestAds = await ConsentInformation.instance.canRequestAds();

      if (canRequestAds && !_started) {
        _started = true;

        if (_adTestDeviceIds.isNotEmpty) {
          await MobileAds.instance.updateRequestConfiguration(
            RequestConfiguration(testDeviceIds: _adTestDeviceIds),
          );
        }

        await MobileAds.instance.initialize();
      }

      if (!_allowed.isCompleted) _allowed.complete(canRequestAds);

      return (
        canRequestAds: canRequestAds,
        privacyOptionsRequired:
            await ConsentInformation.instance
                .getPrivacyOptionsRequirementStatus() ==
            PrivacyOptionsRequirementStatus.required,
      );
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Gathering consent failed; no ads this session',
        exception: error,
        stackTrace: stackTrace,
      );

      if (!_allowed.isCompleted) _allowed.complete(false);

      return (canRequestAds: false, privacyOptionsRequired: false);
    }
  }

  @override
  Future<void> showPrivacyOptions() {
    final shown = Completer<void>();

    try {
      ConsentForm.showPrivacyOptionsForm((error) {
        if (error != null) _logFormError('Showing the privacy options', error);

        shown.complete();
      });
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Showing the privacy options failed',
        exception: error,
        stackTrace: stackTrace,
      );
      shown.complete();
    }

    return shown.future;
  }

  Future<void> _showFormIfRequired() {
    final shown = Completer<void>();

    ConsentForm.loadAndShowConsentFormIfRequired((error) {
      if (error != null) _logFormError('Showing the consent form', error);

      shown.complete();
    });

    return shown.future;
  }

  /// Every launch, as the SDK asks: the answer may have expired, or the
  /// player moved into a region that needs one.
  Future<void> _updateConsentInfo() {
    final updated = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(
        consentDebugSettings: _debugEea
            ? ConsentDebugSettings(
                debugGeography: DebugGeography.debugGeographyEea,
                testIdentifiers: _testDeviceIds,
              )
            : null,
      ),
      updated.complete,
      (error) {
        _logFormError('Updating the consent information', error);
        updated.complete();
      },
    );

    return updated.future;
  }

  void _logFormError(String what, FormError error) => Timber.e(
    tag: packageName,
    logMessage: '$what failed: ${error.errorCode} ${error.message}',
  );
}

/// No form and no ads: tests, and builds that never ask.
final class NoConsent implements Consent {
  const NoConsent();

  @override
  Future<bool> adsAllowed() async => false;

  @override
  Future<ConsentOutcome> gather() async =>
      (canRequestAds: false, privacyOptionsRequired: false);

  @override
  Future<void> showPrivacyOptions() async {}
}
