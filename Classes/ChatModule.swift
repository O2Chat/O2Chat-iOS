//
//  ChatModule.swift
//  NewChatDemo2
//
//  Created by Sanjay Kumar on 09/07/2024.
//

import Foundation
import UIKit
import FMDB

//public struct O2ChatWidget {
//    
//    public static func createChatViewController(from viewController: UIViewController, name : String, email : String, phone : String, deviceToken : String, channelId : String) {
//        // Load the storyboard and instantiate the ChatViewController
//        let bundle = Bundle(for: ChatViewController.self)
//        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
//        if let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
//            var dbChatObj = Singleton.sharedInstance.myLocalChatDB
//            print("New Addition")
//            CustomUserDefaultChat.sheard.saveChannelId(channelId: channelId)
//            CustomUserDefaultChat.sheard.setFcmToken(token: deviceToken)
//            CustomUserDefaultChat.sheard.saveCustomerName(customerName: name)
//            CustomUserDefaultChat.sheard.saveCustomerEmail(CustomerEmail: email)
//            CustomUserDefaultChat.sheard.saveCustomerPhoneNumber(customerPhoneNumber: phone)
////            CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: conversationUID)
//            if !CustomUserDefaultChat.sheard.getConversationUuID().isEmpty  {
//                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: CustomUserDefaultChat.sheard.getConversationUuID())
//            }else{
//                let conversationUID = CustomUserDefaultChat.sheard.generateUuID()
//                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: conversationUID)
//                
//            }
//            
//            
//            dbChatObj.CreateChatDatabase()
//            chatViewController.modalPresentationStyle = .fullScreen
//            viewController.present(chatViewController, animated: true, completion: nil)
//        }
//    }
//    
//    public func createDatabase() {
//        var dbChatObj = Singleton.sharedInstance.myLocalChatDB
//        print("New Addition")
//        dbChatObj.CreateChatDatabase()
//    }
//}
//
//@objcMembers public class O2ChatWidgetLogout: NSObject {
//    static public let sharedInstance = O2ChatWidgetLogout()
//    public func logOutUser(){
//        CustomUserDefaultChat.sheard.logOutChatUser()
//    }
//    
//    public func isO2ChatWidgetNotification(_ info: [AnyHashable: Any]) -> Bool {
//        // Implementation to check if a push notification is from Freshchat
//        return false
//    }
//    
//    public func handleRemoteNotification(_ info: [AnyHashable: Any], appState: UIApplication.State) {
//        // Extract information from the notification payload
//        let conversationUID = info["conversationuid"] as? String ?? ""
//        let count = info["count"] as? String ?? "0"
//
//        // Initialize the ChatViewController
//        let bundle = Bundle(for: ChatViewController.self)
//        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
//        if let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
//            // Ensure the Singleton's local chat database is initialized
//            let dbChatObj = Singleton.sharedInstance.myLocalChatDB
//            print("New Addition")
//
//            // Handle conversation UUID
//            if !CustomUserDefaultChat.sheard.getConversationUuID().isEmpty {
//                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: CustomUserDefaultChat.sheard.getConversationUuID())
//            } else {
//                let conversationUID = CustomUserDefaultChat.sheard.generateUuID()
//                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: conversationUID)
//            }
//
//            // Create chat database if not exists
//            dbChatObj.CreateChatDatabase()
//
//            // Set the presentation style
//            chatViewController.modalPresentationStyle = .fullScreen
//
//            // Present the ChatViewController
//            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
//                if appState == .active {
//                    // If the app is active, present the view controller normally
//                    rootViewController.present(chatViewController, animated: true, completion: nil)
//                } else {
//                    // If the app is in the background or inactive, ensure the root view controller is visible
//                    rootViewController.dismiss(animated: false, completion: {
//                        rootViewController.present(chatViewController, animated: true, completion: nil)
//                    })
//                }
//            }
//        }
//    }
//    
//}

import UIKit

public class O2ChatWidget {
    // Singleton instance
    public static let shared = O2ChatWidget()

    // Private initializer to enforce singleton pattern
    private init() {}
    
    // Flag to track if the app is fully launched
    private var isAppFullyLaunched = false
    private var isAppKilled = false
    
    // Method to create and present ChatViewController
    public func presentChatViewController(from viewController: UIViewController, name: String, email: String, phone: String, deviceToken: String, channelId: String) {
        let bundle = Bundle(for: ChatViewController.self)
        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
        if let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            let dbChatObj = Singleton.sharedInstance.myLocalChatDB
            print("New Addition")
            CustomUserDefaultChat.sheard.saveChannelId(channelId: channelId)
            CustomUserDefaultChat.sheard.setFcmToken(token: deviceToken)
            CustomUserDefaultChat.sheard.saveCustomerName(customerName: name)
            CustomUserDefaultChat.sheard.saveCustomerEmail(CustomerEmail: email)
            CustomUserDefaultChat.sheard.saveCustomerPhoneNumber(customerPhoneNumber: phone)
            if !CustomUserDefaultChat.sheard.getConversationUuID().isEmpty {
                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: CustomUserDefaultChat.sheard.getConversationUuID())
            } else {
                let conversationUID = CustomUserDefaultChat.sheard.generateUuID()
                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: conversationUID)
            }
            dbChatObj.CreateChatDatabase()
            chatViewController.modalPresentationStyle = .fullScreen
            viewController.present(chatViewController, animated: true, completion: nil)
        }
    }
    
    // Method to create and present ChatViewController
    public func presentChatViewControllerFromNotification(from viewController: UIViewController) {
        let bundle = Bundle(for: ChatViewController.self)
        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
        if let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            let dbChatObj = Singleton.sharedInstance.myLocalChatDB
            print("New Addition")
            if !CustomUserDefaultChat.sheard.getConversationUuID().isEmpty {
                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: CustomUserDefaultChat.sheard.getConversationUuID())
            } else {
                let conversationUID = CustomUserDefaultChat.sheard.generateUuID()
                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: conversationUID)
            }
            dbChatObj.CreateChatDatabase()
            chatViewController.modalPresentationStyle = .fullScreen
            viewController.present(chatViewController, animated: true, completion: nil)
        }
    }

    // Method to handle remote notification
    public func handleRemoteNotification(_ info: [AnyHashable: Any], appState: UIApplication.State) {
        let conversationUID = info["conversationuid"] as? String ?? ""
        let count = info["count"] as? String ?? "0"

        let bundle = Bundle(for: ChatViewController.self)
        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
        if let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            let dbChatObj = Singleton.sharedInstance.myLocalChatDB
            print("New Addition")
            if !CustomUserDefaultChat.sheard.getConversationUuID().isEmpty {
                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: CustomUserDefaultChat.sheard.getConversationUuID())
            } else {
                let conversationUID = CustomUserDefaultChat.sheard.generateUuID()
                CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: conversationUID)
            }
            dbChatObj.CreateChatDatabase()
            chatViewController.modalPresentationStyle = .fullScreen

            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                if appState == .active {
                    self.isAppKilledSetter(value: false)
                    rootViewController.present(chatViewController, animated: true, completion: nil)
                } else {
                    // Schedule the presentation for when the app becomes active
                    NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
                        if self?.isAppFullyLaunched == true {
                            //DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            self?.isAppKilledSetter(value: false)
                                rootViewController.present(chatViewController, animated: true, completion: nil)
                                NotificationCenter.default.removeObserver(self!, name: UIApplication.didBecomeActiveNotification, object: nil)
                            //}
                            
                        }
                    }
                }
            }
        }
    }
    
    // Method to create chat database
    public func createDatabase() {
        let dbChatObj = Singleton.sharedInstance.myLocalChatDB
        print("New Addition")
        dbChatObj.CreateChatDatabase()
    }
    
    // Method to be called when app finishes launching
    public func appDidFinishLaunching() {
        isAppFullyLaunched = true
    }
    
    // Method to be called when app finishes launching
    public func isAppKilledSetter(value : Bool) {
        isAppKilled = value
    }
    
    // Method to be called when app finishes launching
    public func isAppKilledGetter() -> Bool{
        return isAppKilled
    }
    
    // Method to log out user
    public func logOutUser() {
        CustomUserDefaultChat.sheard.logOutChatUser()
    }

    // Method to check if a notification is from Freshchat
    public func isO2ChatWidgetNotification(_ info: [AnyHashable: Any]) -> Bool {
        // Implementation to check if a push notification is from Freshchat
        return false
    }
}

//// Usage example for presenting the chat view controller from within the app
//O2ChatManager.shared.presentChatViewController(from: someViewController, name: "User Name", email: "user@example.com", phone: "1234567890", deviceToken: "deviceToken123", channelId: "channelId123")
//
//// Usage example for handling a remote notification
//O2ChatManager.shared.handleRemoteNotification(someNotificationInfo, appState: UIApplication.shared.applicationState)
