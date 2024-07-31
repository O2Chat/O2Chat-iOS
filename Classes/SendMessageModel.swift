//
//  SendMessageModel.swift
//  ConnectMateCustomer
//
//  Created by macbook on 08/05/2023.
//

import Foundation
struct SendMessageModel: Codable {
    var tempChatId : String?
    var customerId : Int64?
    var agentId : Int64?
    var conversationUid : String?
    var conversationDetailId : Int64?
    var conversationId : String?
    var groupId : Int64?
    var groupName : String?
    var message : String?
    var receiverConnectionId : String?
    var receiverName : String?
    var type : String?
    var isFromWidget : Bool?
    var isResolved : Bool?
    var conversationType : String?
    var documentOrignalname : String?
    var documentName : String?
    var documentType : String?
    var icon : String?
    var pageId : String?
    var pageName : String?
    var timezone : String?
    var caption : String?
//    var topicId : Int64?
//    var topicMessage : String?
//    var createdOn : Date?
    var timestamp : String?

    
}
