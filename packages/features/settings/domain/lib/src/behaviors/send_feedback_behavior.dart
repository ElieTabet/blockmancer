import 'package:settings_domain/src/entities/app_details.br.dart';
import 'package:settings_domain/src/providers_di.br.dart';

/// Where feedback goes, and the address shown when no mail app can open.
const feedbackAddress = 'support@elietabet.com';

/// Opens a mail draft to [feedbackAddress] with the build and the phone
/// prefilled, and answers whether one opened.
///
/// The subject and the labels stay in English whatever the app is shown in:
/// support reads them, not the player.
class SendFeedbackBehavior {
  final Future<AppDetails> _appDetails;
  final ComposeEmailFun _composeEmail;

  static const _subject = 'Blockmancer feedback';

  const SendFeedbackBehavior({
    required Future<AppDetails> appDetails,
    required ComposeEmailFun composeEmail,
  }) : _appDetails = appDetails,
       _composeEmail = composeEmail;

  Future<bool> call() async {
    final details = await _appDetails;

    // Opens below what the player writes, so the cursor lands on an empty
    // line rather than in the details.
    final body = [
      '',
      '',
      '---',
      'Version: ${details.version} (${details.build})',
      'Device: ${details.device}',
      'OS: ${details.os}',
    ].join('\n');

    // Encoded by hand: `queryParameters` writes a space as `+`, which mail
    // apps show as a literal plus.
    final mailto = Uri(
      scheme: 'mailto',
      path: feedbackAddress,
      query:
          'subject=${Uri.encodeComponent(_subject)}'
          '&body=${Uri.encodeComponent(body)}',
    );

    return _composeEmail(mailto);
  }
}
