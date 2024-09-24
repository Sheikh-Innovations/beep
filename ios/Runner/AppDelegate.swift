import UIKit
import Flutter
import AVFoundation // Import AVFoundation for audio session management

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Set up the audio session for video calls
    configureAudioSession()

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Function to configure the audio session
  private func configureAudioSession() {
    do {
      // Set the audio session category to play and record, with video chat mode and speaker as default
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .videoChat, options: .defaultToSpeaker)

      // Activate the audio session
      try AVAudioSession.sharedInstance().setActive(true)

      print("Audio session configured successfully")
    } catch {
      print("Error setting AVAudioSession: \(error)")
    }
  }
}
