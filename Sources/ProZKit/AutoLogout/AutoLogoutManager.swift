//
//  AutoLogoutManager.swift
//  testabu
//
//  Created by Low Jung Xuan on 17/3/25.
//

import Foundation
import UIKit

@MainActor
public class AutoLogoutManager {
    public static let shared = AutoLogoutManager()
    
    /// Timeout interval in seconds.
    private var timeoutInterval: Int = 3600
    
    /// Remaining seconds before auto logout.
    private var remainingSeconds: Int = 3600
    
    /// Timer that fires every second.
    private var timer: Timer?
    
    /// Flag to indicate whether the user has been logged out.
    private var isLoggedOut: Bool = false
    
    /// Callback executed when auto logout should occur.
    public var onLogout: (() -> Void)?
    
    public func initialize(isLogin: Bool? = nil, timeoutInterval: Int = 3600) {
        self.timeoutInterval = timeoutInterval
        remainingSeconds = self.timeoutInterval
        
        // Listen for when the application becomes active.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resetTimer),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // If user is already logged in, call loginUser.
        if let isLogin = isLogin, isLogin {
            loginUser()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Call this method to re-enable the timer when a user logs in.
    public func loginUser() {
        isLoggedOut = false
        
        // Store the current login time in UserDefaults.
        UserDefaults.standard.set(Date(), forKey: "loginTime")
        
        resetTimer()
    }
    
    /// Start or reset the countdown timer.
    @objc public func resetTimer() {
        // Do not reset if the user has already been logged out.
        if isLoggedOut {
            return
        }
        
        // Retrieve login time from UserDefaults.
        guard let loginTime = UserDefaults.standard.object(forKey: "loginTime") as? Date else {
            // If there is no login time, immediately log out.
            logoutUser()
            return
        }
        
        // Calculate elapsed time since login.
        let elapsedTime = Date().timeIntervalSince(loginTime)
        let calculatedRemaining = timeoutInterval - Int(elapsedTime)
        
        // If the elapsed time exceeds the timeout interval, log out.
        if calculatedRemaining <= 0 {
            logoutUser()
            return
        }
        
        // Update the remaining seconds.
        remainingSeconds = calculatedRemaining
        
        // Invalidate any existing timer and start a new one.
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true
        )
    }
    
    /// Called every second by the timer.
    @objc private func timerTick() {
        remainingSeconds -= 1
        if remainingSeconds % 10 == 0 {
            // Log remaining seconds (replace with your logging mechanism as needed).
            PrettyLogger.info("Remaining seconds: \(remainingSeconds)")
        }
        if remainingSeconds <= 0 {
            logoutUser()
        }
    }
    
    /// Perform logout actions.
    public func logoutUser() {
        timer?.invalidate()
        timer = nil
        isLoggedOut = true
        
        // Optionally clear the stored login time on logout.
        UserDefaults.standard.removeObject(forKey: "loginTime")
        
        onLogout?()
    }
    
    /// Optionally, stop monitoring altogether.
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
