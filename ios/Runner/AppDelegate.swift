import UIKit
import Flutter

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    MSAppCenter.start("e778ce97-e493-466f-950c-4b54e6ff5b39", withServices:[
      MSAnalytics.self,
      MSCrashes.self
    ])
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
