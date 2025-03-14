//
//  AppDelegate.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 14/2/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? // Add this property

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        _ = AutoLogoutManager.shared // 激活单例
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

//
// final class AutoLogoutManager {
//    static let shared = AutoLogoutManager()
//    private init() {
//        // 仅注册通知
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(appDidBecomeActive),
//                                               name: UIApplication.didBecomeActiveNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(appWillResignActive),
//                                               name: UIApplication.willResignActiveNotification,
//                                               object: nil)
//    }
//
//    private let autoLogoutInterval: TimeInterval = 10
//    private var logoutTimer: Timer?
//    private var bgTime: Date?
//
//    @objc private func appDidBecomeActive() {
//        // 调整定时器（如果有后台记录）
//        if let bgTime {
//            let duration = Date().timeIntervalSince(bgTime)
//            adjustTimer(for: duration)
//        }
//        // 如果 expiredDate 存在，按照逻辑处理；否则如果用户已登录，则初始化 expiredDate
//        if let exp = UserDefaults.standard.object(forKey: "expiredDate") as? Date {
//            Date() >= exp ? triggerLogout() : renewExpirationDate()
//        } else if isUserLoggedIn() {
//            print("No expiredDate found, but user is logged in. Initializing expiredDate.")
//            renewExpirationDate()
//        }
//    }
//
//    @objc private func appWillResignActive() {
//        bgTime = Date()
//        logoutTimer?.invalidate()
//    }
//
//    private func renewExpirationDate() {
//        let newExp = Date().addingTimeInterval(autoLogoutInterval)
//        UserDefaults.standard.set(newExp, forKey: "expiredDate")
//        scheduleTimer()
//    }
//
//    private func scheduleTimer() {
//        logoutTimer?.invalidate()
//        guard let exp = UserDefaults.standard.object(forKey: "expiredDate") as? Date else { return }
//        let interval = exp.timeIntervalSince(Date())
//        if interval <= 0 {
//            triggerLogout()
//            return
//        }
//        logoutTimer = Timer.scheduledTimer(timeInterval: interval,
//                                           target: self,
//                                           selector: #selector(triggerLogout),
//                                           userInfo: nil,
//                                           repeats: false)
//    }
//
//    private func adjustTimer(for duration: TimeInterval) {
//        guard let exp = UserDefaults.standard.object(forKey: "expiredDate") as? Date else { return }
//        let remaining = exp.timeIntervalSince(Date()) - duration
//        remaining <= 0 ? triggerLogout() : scheduleTimer()
//    }
//
//    @objc private func triggerLogout() {
//        DispatchQueue.main.async {
//            guard let topVC = UIViewController.topMostViewController() else { return }
//            let alert = UIAlertController(title: "会话过期",
//                                          message: "请重新登录",
//                                          preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
//                self.performLogout()
//            })
//            topVC.present(alert, animated: true)
//        }
//    }
//
//    private func performLogout() {
//        // 仅在真正登出时移除 expiredDate
//        UserDefaults.standard.removeObject(forKey: "expiredDate")
//        logoutTimer?.invalidate()
//        if let window = UIApplication.shared.keyWindow {
//            window.rootViewController = ViewController() // 登录界面
//            window.makeKeyAndVisible()
//        }
//    }
//
//    // 模拟用户登录状态的判断函数，根据实际业务替换实现
//    private func isUserLoggedIn() -> Bool {
//        // 例如通过检测用户 token、用户 ID 等
//        true
//    }
//
//    func handleLoginSuccess() {
//        renewExpirationDate()
//    }
// }
//
// extension UIViewController {
//    static func topMostViewController() -> UIViewController? {
//        guard let root = UIApplication.shared.keyWindow?.rootViewController else { return nil }
//        return topVC(from: root)
//    }
//
//    private static func topVC(from vc: UIViewController) -> UIViewController {
//        if let p = vc.presentedViewController {
//            return topVC(from: p)
//        }
//        if let nav = vc as? UINavigationController, let top = nav.topViewController {
//            return topVC(from: top)
//        }
//        if let tab = vc as? UITabBarController, let sel = tab.selectedViewController {
//            return topVC(from: sel)
//        }
//        return vc
//    }
// }
