//
//  Notification.swift
//  O2ChatWidget
//
//  Created by Sanjay Kumar on 14/05/2024.
//

import Foundation
// MARK: - Welcome
struct NotificationData : Codable {
    var notificationId: String?
    var notificationCategoryId: String?
    var recordId: String?
    var urlImageString : String?
    
    init(notificationId : String, notificationCategoryId : String, recordId : String, urlImageString : String){
        self.notificationId = notificationId
        self.notificationCategoryId = notificationCategoryId
        self.recordId = recordId
        self.urlImageString = urlImageString
    }
}

struct NotificationChatData : Codable {
    var conversationUid: String?
    var count: Int?
    
    init(conversationUid: String?, count: Int?){
        self.conversationUid = conversationUid
        self.count = count
        
    }
}
