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
    
    /// Timeout interval in seconds
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
        self.timeoutInterval = timeoutInterval ?? 3600
        remainingSeconds = self.timeoutInterval
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resetTimer),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        if let isLogin = isLogin, isLogin {
            resetTimer()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Call this method to re-enable the timer when a user logs in.
    public func loginUser() {
        isLoggedOut = false
        resetTimer()
    }
    
    /// Start or reset the countdown timer.
    @objc public func resetTimer() {
        // Do not reset if the user has already been logged out.
        if isLoggedOut {
            return
        }
        
        timer?.invalidate()
        remainingSeconds = timeoutInterval
        // Start a repeating timer that fires every second.
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
        onLogout?()
    }
    
    /// Optionally, stop monitoring altogether.
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
