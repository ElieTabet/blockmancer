import AVFoundation
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    clearBadgeWhenActive()
    mixSoundWithOtherApps()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // The game's sounds play over the player's music rather than stopping it, and
  // go quiet with the silent switch. flutter_soloud leaves the session's
  // category to the app, so this is the only place it is set.
  private func mixSoundWithOtherApps() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.ambient)
    } catch {
      NSLog("The audio session could not be set to ambient: \(error)")
    }
  }

  // Content pushes set the icon badge to 1, and the server can't know when it
  // has been seen: opening the app is that moment, cold start or resume alike.
  // Observed rather than a SceneDelegate override, which would replace the
  // FlutterSceneDelegate callback that reports the resume to Dart.
  private func clearBadgeWhenActive() {
    NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: .main
    ) { _ in
      UNUserNotificationCenter.current().setBadgeCount(0)
    }
  }
}
