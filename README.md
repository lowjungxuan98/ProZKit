# ProZKit

ProZKit is a Swift Package that provides a customizable call bottom view component for iOS applications. It features an attractive, gradient-backed view with built-in call control buttons, a call timer, and configurable labels for displaying clinic and doctor information.

## Features

- **Custom Bottom View (`ATCallBottomView`):**  
  A fully customizable view designed for call interfaces with a gradient background.

- **Call Control Buttons:**  
  Built-in mute, end call, and switch camera buttons. Each button supports default SF Symbol icons and can be customized via a public API.

- **Configurable Information:**  
  Easily set the clinic name, doctor name, and doctor number. The dash separator automatically hides if either the doctor name or doctor number is missing.

- **Timer Functionality:**  
  Displays a call timer that updates in "MM:SS" format for calls under one hour and "HH:MM:SS" for longer calls. Start and stop the timer with simple method calls.

- **Pretty Logging:**  
  (Optional) A custom logger can be integrated for standardized log messages with timestamps and a ProZKit prefix.

## Installation

ProZKit is available via Swift Package Manager. To add ProZKit to your project:

1. In Xcode, select **File > Swift Packages > Add Package Dependency...**
2. Enter the repository URL (for example, `https://github.com/yourusername/ProZKit.git`).
3. Follow the prompts to add the package to your project.

## Usage

Import ProZKit in your code:

```swift
import ProZKit
```

### Example: Integrating `ATCallBottomView`

```swift
// Create an instance of ATCallBottomView with a defined frame.
let callView = ATCallBottomView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))

// Configure clinic and doctor information.
// The dash separator will hide if either doctor name or number is missing.
callView.configureInfo(clinicName: "Health Clinic", doctorName: "Dr. Smith", doctorNumber: "12345")

// Set up button actions for mute, end call, and switch camera.
callView.setButtonActions(muteAction: {
    // Handle mute button tap
    print("Mute button tapped")
}, endCallAction: {
    // Handle end call button tap
    print("End call button tapped")
}, switchCameraAction: {
    // Handle switch camera button tap
    print("Switch camera button tapped")
})

// Start the call timer.
callView.startTimer()

// Add the call view to your view controller's view and set up constraints.
view.addSubview(callView)
// Configure Auto Layout constraints as needed.
```

## Demo

For a complete example of how to integrate and use ProZKit, refer to the included **ProZKitDemo** project in this repository.

## Contributing

Contributions to ProZKit are welcome! If you have ideas for improvements, bug fixes, or new features, please open an issue or submit a pull request.

## License

ProZKit is released under the MIT License. See the [LICENSE](LICENSE) file for details.
