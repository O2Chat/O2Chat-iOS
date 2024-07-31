//
//  SwiftEEventBus.swift
//  NewChatDemo2
//
//  Created by Sanjay Kumar on 12/07/2024.
//

import Foundation

// Define a class to handle notifications
class SwiftEventBus {
    static let shared = SwiftEventBus()
    
    private init() {}
    
    // Function to post notifications
    func post(eventName: String, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: Notification.Name(eventName), object: nil, userInfo: userInfo)
    }
    
    // Function to add an observer
    func addObserver(_ observer: Any, selector: Selector, eventName: String) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(eventName), object: nil)
    }
    
    // Function to remove an observer
    func removeObserver(_ observer: Any, eventName: String) {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name(eventName), object: nil)
    }
    
    // Function to remove an observer for all events
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
