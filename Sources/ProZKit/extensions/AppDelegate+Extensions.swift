//
//  AppDelegate+Extensions.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 12/3/25.
//

import Foundation
import UIKit

// extension AppDelegate {
//    var topViewController: UIViewController? {
//        guard let rootViewController = window?.rootViewController else { return nil }
//        return getTopViewController(from: rootViewController)
//    }
//
//    private func getTopViewController(from viewController: UIViewController) -> UIViewController {
//        if let nav = viewController as? UINavigationController {
//            return getTopViewController(from: nav.visibleViewController ?? nav)
//        } else if let tab = viewController as? UITabBarController {
//            if let selected = tab.selectedViewController {
//                return getTopViewController(from: selected)
//            }
//            return tab
//        } else if let presented = viewController.presentedViewController {
//            return getTopViewController(from: presented)
//        }
//        return viewController
//    }
// }
