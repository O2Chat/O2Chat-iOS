//
//  AppDelegate.swift
//  O2Chat
//
//  Created by sanjay.khatri02@outlook.com on 07/30/2024.
//  Copyright (c) 2024 sanjay.khatri02@outlook.com. All rights reserved.
//

import UIKit
import O2ChatSDK
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize Firebase SDK
        //FirebaseApp.configure()

        // Enable auto-initialization for Firebase Messaging
        //Messaging.messaging().isAutoInitEnabled = true
        
        // Register the app for push notifications
       // self.registerForPushNotifications(application: application)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// Extension of AppDelegate for handling Push Notification and Firebase Messaging functionalities
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

    // Method to register for push notifications
    func registerForPushNotifications(application: UIApplication) {
        
        // Check for iOS 10.0 and above, as notification handling differs
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self  // Set the notification center's delegate
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if granted {
                    // If permission is granted, register for remote notifications
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    // Handle if the user denies notification permissions
                    // You can alert the user or take appropriate action
                }
            })
        } else {
            // For iOS versions below 10.0, use older notification registration methods
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        
        // Set Firebase Messaging delegate
        Messaging.messaging().delegate = self
    }

    // This method is called when the FCM (Firebase Cloud Messaging) registration token is received
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        // Here, you can send the FCM token to your server for future push notifications
    }

    // Called when the device has successfully registered for remote notifications with APNs (Apple Push Notification service)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Set the APNs token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    // Called when a notification is delivered while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification, withCompletionHandler: @escaping (UNNotificationPresentationOptions) -> ()) {
        // Specify how the notification should be presented when the app is in the foreground (alert, sound, badge)
        withCompletionHandler([.alert, .sound, .badge]) // Present the notification with these options
    }

    // Called when a user interacts with a notification (e.g., tapping on it)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive: UNNotificationResponse, withCompletionHandler: @escaping () -> ()) {
        let userInfo = didReceive.notification.request.content.userInfo  // Extract the notification payload

        // Tell Firebase Messaging that the app received a message for analytics purposes
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print the full notification payload for debugging
        print(userInfo)
        
        // Extract the notification's "aps" (Apple Push Service) dictionary
        guard let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
              let alert = aps["alert"] as? NSDictionary,
              let body = alert["body"] as? String,
              let title = alert["title"] as? String else {
            // If "aps" or "alert" info is missing, do nothing
            return
        }
        
        // Example: Handle custom data from the notification payload (e.g., conversation UID and count)
        let conversationuid = userInfo[AnyHashable("conversationuid")] as? String ?? ""
        let count = userInfo[AnyHashable("count")] as? String ?? "0"
        
        // Check if the app was launched due to this notification or if the app is already active
        if !conversationuid.isEmpty {
            if UIApplication.shared.applicationState == .inactive {
                // App was launched from a killed state
                O2Chat.shared.isAppLauncedFromKilledStateSetter(value: true)
            } else {
                // App is running, handle the notification while app is active or in the background
                O2Chat.shared.isAppLauncedFromKilledStateSetter(value: false)
                O2Chat.shared.handleRemoteNotification(userInfo, appState: UIApplication.shared.applicationState)
            }
        } else {
            // Handle other apps' notifications or if no specific data for your app
        }

        // Call the completion handler after handling the notification
        withCompletionHandler()
    }
}
