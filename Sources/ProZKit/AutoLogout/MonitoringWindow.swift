//
//  MonitoringWindow.swift
//  eHealthAssist
//
//  Created by Low Jung Xuan on 17/3/25.
//  Copyright © 2025 assurance. All rights reserved.
//

import UIKit

public class MonitoringWindow: UIWindow {
    public override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        AutoLogoutManager.shared.resetTimer()
    }
}
