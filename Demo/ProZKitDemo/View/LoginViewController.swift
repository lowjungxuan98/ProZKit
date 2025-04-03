//
//  LoginViewController.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 3/4/25.
//

import Foundation
import UIKit
import ProZKit

class LoginViewController: UIViewController {
    // login button at the center
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleLogin() {
        UserDefaults.standard.set(true, forKey: "isLogin")
        AutoLogoutManager.shared.loginUser()
        guard let windowScene = view.window?.windowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }
        let vc = ViewController()
        window.rootViewController = UINavigationController(rootViewController: vc)
    }
    
    override func viewDidLoad() {
        title = "Login"
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
