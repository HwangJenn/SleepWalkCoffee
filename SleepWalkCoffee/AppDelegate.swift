//
//  AppDelegate.swift
//  SleepWalkCoffee
//
//  Created by 황지현 on 2023/04/09.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
// import SquareInAppPaymentsSDK 인앱결제
import Accessibility

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        //SQIPInAppPaymentsSDK.squareApplicationID = Constants.Square.APPLICATION_ID
        if UserDefaults.standard.isUserLoggedIn() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainNC = storyboard.instantiateViewController(withIdentifier: "MainNC")
            window?.rootViewController = mainNC
            window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginNC = storyboard.instantiateViewController(withIdentifier: "LoginNC")
            window?.rootViewController = loginNC
            window?.makeKeyAndVisible()
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        return true
    }

    // MARK: UISceneSession Lifecycle
/*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    } */


}

