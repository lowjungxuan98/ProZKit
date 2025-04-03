//
//  AppDelegate.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 14/2/25.
//

import UIKit
import ProZKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? // Add this property

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AutoLogoutManager.shared.onLogout = {
            UserDefaults.standard.set(false, forKey: "isLogin")
            guard let windowScene = self.window?.windowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate,
                  let window = sceneDelegate.window else {
                return
            }
            let vc = LoginViewController()
            window.rootViewController = UINavigationController(rootViewController: vc)
        }
        AutoLogoutManager.shared.initialize(isLogin: UserDefaults.standard.bool(forKey: "isLogin"), timeoutInterval: 20)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AutoLogoutManager.shared.resetTimer()
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}
}
