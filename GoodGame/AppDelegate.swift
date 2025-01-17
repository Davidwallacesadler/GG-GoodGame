//
//  AppDelegate.swift
//  GoodGame
//
//  Created by David Sadler on 9/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let defaults = UserDefaults()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        onFirstLaunch()
        return true
    }
    
    private func onFirstLaunch() {
           let firstLaunch = FirstLaunch(userDefaults: .standard, key: Keys.FirstLaunchKey)
           if firstLaunch.isFirstLaunch {
            UserDefaults.standard.set(true, forKey: Keys.onboardingKey)
           }
       }

    
    // MARK: - UISceneSession Lifecycle
    

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

