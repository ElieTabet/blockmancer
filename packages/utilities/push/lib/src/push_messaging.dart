/// The phone's push plumbing, behind a contract that mentions no vendor.
///
/// A tapped notification comes out as its `data`, string to string, and nothing
/// more: what the keys mean is the business of whoever routes on them.
abstract interface class PushMessaging {
  /// The current registration token, or null when there isn't one yet — iOS
  /// before APNs has answered, or Android without Play services.
  ///
  /// Never throws. A caller reporting telemetry should not have to decide what
  /// a messaging fault means.
  Future<String?> currentToken();

  /// Channel creation, iOS foreground presentation, and Android's foreground
  /// listener.
  ///
  /// Called once per launch rather than once per install: re-creating the
  /// channel is what re-localizes [channelName] and [channelDescription] after
  /// the phone's language changes.
  Future<void> initialize({
    required String channelDescription,
    required String channelName,
  });

  /// The data of the notification whose tap launched the app, or null when
  /// something else did. Answers once per launch; never throws.
  Future<Map<String, String>?> launchMessage();

  /// The data of every notification tapped while the app is alive, in the
  /// background or in front.
  Stream<Map<String, String>> get openedMessages;

  /// The data of every push that arrives while the app is in front — shown or
  /// not, tapped or not. A push arriving in the background never reaches it.
  Stream<Map<String, String>> get receivedMessages;

  /// Shows the OS prompt when there is no decision on record, and returns the
  /// standing answer when there is. The OS is what suppresses a second prompt,
  /// so no caller tracks whether it has asked.
  Future<bool> requestPermission();

  Stream<String> get tokenChanges;
}
