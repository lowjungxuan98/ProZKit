# AutoLogoutManager

A utility to automatically log users out after a period of inactivity.

## Integration

### Key Steps
1. Initialize with user login status
2. Set up logout callback
3. Reset timer when app becomes active
4. Call `loginUser()` when user logs in
5. Call `logoutUser()` when user logs out manually

### Implementation

#### For UIKit with SceneDelegate
```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Set up window and view controllers
        
        // Configure AutoLogoutManager
        AutoLogoutManager.shared.onLogout = {
            // Implement your logout logic here
        }
        AutoLogoutManager.shared.initialize(isLogin: Global.user?.isLogin)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        AutoLogoutManager.shared.resetTimer()
    }
}
```

#### For UIKit with AppDelegate (iOS 12 and earlier)
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set up window and view controllers
        
        // Configure AutoLogoutManager
        AutoLogoutManager.shared.onLogout = {
            // Implement your logout logic here
        }
        AutoLogoutManager.shared.initialize(isLogin: Global.user?.isLogin)
        return true
    }
    
    func applicationDidBecomeActive(_: UIApplication) {
        AutoLogoutManager.shared.resetTimer()
    }
}
```

### Managing Login/Logout Events

When a user logs in or out, call the appropriate methods:

```swift
// When user logs in
AutoLogoutManager.shared.loginUser()

// When user logs out manually
AutoLogoutManager.shared.logoutUser()
```

