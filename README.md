# O2Chat
![O2Chat : Swift](https://github.com/O2Chat/O2Chat-iOS/blob/main/Resource/O2ChatLogo.png)

[![Version](https://img.shields.io/cocoapods/v/O2Chat.svg?style=flat)](https://cocoapods.org/pods/O2Chat)
[![License](https://img.shields.io/cocoapods/l/O2Chat.svg?style=flat)](https://cocoapods.org/pods/O2Chat)
[![Platform](https://img.shields.io/cocoapods/p/O2Chat.svg?style=flat)](https://cocoapods.org/pods/O2Chat)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

O2Chat is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'O2Chat', :tag => '0.3.6', :git => 'https://github.com/O2Chat/O2Chat-iOS.git'
```

## Integration and Usage

### Import the SDK
To use the SDK, import it into your project files:
```swift
import O2ChatSDK
```

### Configure the Chat Module
#### Initialize the SDK
Add the following configuration code in your app's `AppDelegate` file or main entry point:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Customize navigation bar and interface colors
    O2Chat.shared.HeaderColor = UIColor.primary // Navigation bar color
    O2Chat.shared.BackIconColor = UIColor.white // Back icon color
    O2Chat.shared.LabelHeadingColor = UIColor.white // Title color

    return true
}
```

#### Start the Chat Module
To present the chat module, provide customer details and invoke the following code:
```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    // Provide required data
    let CustomerName = "First Name"
    let CustomerEmail = "Email Address"
    let CustomerPhone = "Phone Number"
    let ChannelId = "example-5b2e-4227-a456-eab45924a1d3"
    let CustomerCNIC = "Cnic"
    let DeviceTokenFCM = "FCM Token"

    // Start chat module
    O2Chat.shared.presentO2ChatVC(
        from: self,
        customerName: CustomerName,
        customerEmail: CustomerEmail,
        customerPhone: CustomerPhone,
        customerCNIC: CustomerCNIC,
        deviceTokenFCM: DeviceTokenFCM,
        channelId: ChannelId
    )
}
```

### Handle Notifications
#### Configure Notifications
Add this method in your `AppDelegate` or notification manager:
```swift
func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
    if appState == .background || appState == .inactive {
        if AppDelegate.isFromAppLaunched {
            AppDelegate.isFromAppLaunched = false
            O2Chat.shared.isAppLauncedFromKilledStateSetter(value: true)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                O2Chat.shared.handleRemoteNotification(response.notification.request.content.userInfo, appState: .active)
            }
        }
    } else if appState == .active {
        O2Chat.shared.isAppLauncedFromKilledStateSetter(value: false)
        O2Chat.shared.handleRemoteNotification(response.notification.request.content.userInfo, appState: .active)
    }

    completionHandler() // For other notifications
}
```

#### Handle Notifications When App is Terminated
Use this code in your main class to handle notifications when the app is launched from a terminated state:
```swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if O2Chat.shared.isAppLauncedFromKilledStateGetter() == true {
        O2Chat.shared.isAppLauncedFromKilledStateSetter(value: false)
        O2Chat.shared.presentChatViewControllerFromNotification(from: self)
    }
}
```

### Required Permissions
Ensure the following permissions are added to your `Info.plist` file for accessing the photo library, camera, and microphone:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library for sharing media files.</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera for capturing photos and videos.</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for voice communications.</string>
```

---

#### Samples
[Example](https://github.com/O2Chat/O2Chat-iOS/tree/main/Example)

## Support
o2chat.io@gmail.com

## License

O2Chat is available under the MIT license. See the LICENSE file for more info.
