//
//  ChatModule.swift
//  NewChatDemo2
//
//  Created by Sanjay Kumar on 09/07/2024.
//

import Foundation
import UIKit
import FMDB

public class O2Chat {
    // Singleton instance
    public static let shared = O2Chat()

    // Private initializer to enforce singleton pattern
    private init() {}
    
    // Flag to track if the app is fully launched
    private var isAppFullyLaunched = false
    private var isAppKilledState = false
    
    // Method to create and present ChatViewController
    public func presentO2ChatVC(from viewController: UIViewController, customerName: String, customerEmail: String, customerPhone: String, customerCNIC : String, deviceTokenFCM: String, channelId: String) {
        let bundle = Bundle(for: ChatViewController.self)
        let storyboard = UIStoryboard(name: "MainChat", bundle: bundle)
        if let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            let dbChatObj = Singleton.sharedInstance.myLocalChatDB
            print("New Addition")
            CustomUserDefaultChat.sheard.saveChannelId(channelId: channelId)
            CustomUserDefaultChat.sheard.setFcmToken(token: deviceToken)
            CustomUserDefaultChat.sheard.saveCustomerName(customerName: customerName)
            CustomUserDefaultChat.sheard.saveCustomerEmail(CustomerEmail: customerEmail)
            CustomUserDefaultChat.sheard.saveCustomerPhoneNumber(customerPhoneNumber: customerPhone)
            CustomUserDefaultChat.sheard.saveCustomerCnic(customerCnic: customerCNIC)
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
    public func isAppLauncedFromKilledStateSetter(value : Bool) {
        isAppKilledState = value
    }
    
    // Method to be called when app finishes launching
    public func isAppLauncedFromKilledStateGetter() -> Bool{
        return isAppKilledState
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
