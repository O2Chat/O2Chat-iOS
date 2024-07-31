//
//  NotificationManager.swift
//  NewChatDemo2
//
//  Created by Sanjay Kumar on 19/07/2024.
//

import Foundation
//
//  NotificationManager.swift
//  Ridetify
//
//  Created by Sanjay Kumar on 19/07/2024.
//

import Foundation
import Foundation
import UserNotifications
//import Firebase
//
//public class NotificationManager: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
//    
//    public static let shared = NotificationManager()
//    
//    private override init() {
//        super.init()
//        UNUserNotificationCenter.current().delegate = self
//        Messaging.messaging().delegate = self
//    }
//    
//    public func requestNotificationAuthorization(application: UIApplication) {
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                DispatchQueue.main.async {
//                    application.registerForRemoteNotifications()
//                }
//            } else {
//                // Handle the case where permission was denied
//                print("Notification permission denied.")
//            }
//        }
//    }
//    
//    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
//        let token = tokenParts.joined()
//        print("Device Token: \(token)")
//        Messaging.messaging().apnsToken = deviceToken
//    }
//    
//    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register for remote notifications: \(error)")
//    }
//    
//    // UNUserNotificationCenterDelegate methods
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound, .badge])
//    }
//    
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Handle notification data
//        completionHandler()
//    }
//    
//    // MessagingDelegate method
//    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("FCM registration token: \(String(describing: fcmToken))")
//    }
//}

/**
 import Foundation
 import UserNotifications
 import Firebase

 public class NotificationManager: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
     
     public static let shared = NotificationManager()
     
     private override init() {
         super.init()
         UNUserNotificationCenter.current().delegate = self
         Messaging.messaging().delegate = self
     }
     
     public func requestNotificationAuthorization(application: UIApplication) {
         let center = UNUserNotificationCenter.current()
         center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
             if granted {
                 DispatchQueue.main.async {
                     application.registerForRemoteNotifications()
                 }
             } else {
                 // Handle the case where permission was denied
                 print("Notification permission denied.")
             }
         }
     }
     
     public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
         let token = tokenParts.joined()
         print("Device Token: \(token)")
         Messaging.messaging().apnsToken = deviceToken
     }
     
     public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register for remote notifications: \(error)")
     }
     
     // UNUserNotificationCenterDelegate methods
     public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         completionHandler([.alert, .sound, .badge])
     }
     
     public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         let userInfo = response.notification.request.content.userInfo
         // Handle notification data
         completionHandler()
     }
     
     // MessagingDelegate method
     public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
         print("FCM registration token: \(String(describing: fcmToken))")
     }
 }

 */
