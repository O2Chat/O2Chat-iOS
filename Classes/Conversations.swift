//
//  Conversations.swift
//  ConnectMateCustomer
//
//  Created by macbook on 08/05/2023.
//

import Foundation
// MARK: - Welcome
struct Conversations: Decodable {
    var id : Int64?
    var customerId : Int64?
    var customerConnectionId : String?
    var customerEmail : String?
    var toUserId : Int64?
    var agentId : Int64?
    var status : Int64? //String?
    var tempChatId : String?
    var fromUserId : Int64?
    var groupId : Int64?
    var conversationId : Int64?
    var content : String?
    var timestamp : String?
    var sender : String?
    var receiver : String?
    var type : String?
    var source : String?
    var groupName : String?
    var forwardedTo : Int64?
    var customerName : String?
    var conversationUid : String?
    var isAgentReplied : Bool?
    var isResolved : Bool?
    var childConversationCount : Int64?
    var conversationType : String?
    var isRecordUpdated : Bool?
    var isFromWidget : Bool?
    var isNewMessageReceive : Bool?
    var caption : String?
    var rating : Int?
    var feedback : String?
    var errorCode : String?
    var errorCodeDescription : String?
    var files : [FileDataModel]? = [FileDataModel]()
    

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case customerId = "customerId"
        case customerConnectionId = "customerConnectionId"
        case customerEmail = "customerEmail"
        case toUserId = "toUserId"
        case agentId = "agentId"
        case status = "status"
        case tempChatId = "tempChatId"
        case fromUserId = "fromUserId"
        case groupId = "groupId"
        case conversationId = "conversationId"
        case content = "content"
        case timestamp = "timestamp"
        case sender = "sender"
        case receiver = "receiver"
        case type = "type"
        case source = "source"
        case groupName = "groupName"
        case forwardedTo = "forwardedTo"
        case customerName = "customerName"
        case conversationUid = "conversationUid"
        case isAgentReplied = "isAgentReplied"
        case isResolved = "isResolved"
        case isFromWidget = "isFromWidget"
        case childConversationCount = "childConversationCount"
        case conversationType = "conversationType"
        case isRecordUpdated = "isRecordUpdated"
        case isNewMessageReceive = "isNewMessageReceive"
        case caption = "caption"
        case rating = "rating"
        case feedback = "feedback"
        case errorCode = "errorCode"
        case errorCodeDescription = "errorCodeDescription"
        case files = "files"
        
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int64.self, forKey: .id)
        customerId = try values.decodeIfPresent(Int64.self, forKey: .customerId)
        customerConnectionId = try values.decodeIfPresent(String.self, forKey: .customerConnectionId)
        customerEmail = try values.decodeIfPresent(String.self, forKey: .customerEmail)
        toUserId = try values.decodeIfPresent(Int64.self, forKey: .toUserId)
        agentId = try values.decodeIfPresent(Int64.self, forKey: .agentId)
        status = try values.decodeIfPresent(Int64.self, forKey: .status)
        tempChatId = try values.decodeIfPresent(String.self, forKey: .tempChatId)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        fromUserId = try values.decodeIfPresent(Int64.self, forKey: .fromUserId)
        groupId = try values.decodeIfPresent(Int64.self, forKey: .groupId)
        conversationId = try values.decodeIfPresent(Int64.self, forKey: .conversationId)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        sender = try values.decodeIfPresent(String.self, forKey: .sender)
        receiver = try values.decodeIfPresent(String.self, forKey: .receiver)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        forwardedTo = try values.decodeIfPresent(Int64.self, forKey: .forwardedTo)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        conversationUid = try values.decodeIfPresent(String.self, forKey: .conversationUid)
        isAgentReplied = try values.decodeIfPresent(Bool.self, forKey: .isAgentReplied)
        isResolved = try values.decodeIfPresent(Bool.self, forKey: .isResolved)
        isFromWidget = try values.decodeIfPresent(Bool.self, forKey: .isFromWidget)
        childConversationCount = try values.decodeIfPresent(Int64.self, forKey: .childConversationCount)
        conversationType = try values.decodeIfPresent(String.self, forKey: .conversationType)
        isRecordUpdated = try values.decodeIfPresent(Bool.self, forKey: .isRecordUpdated)
        isNewMessageReceive = try values.decodeIfPresent(Bool.self, forKey: .isNewMessageReceive)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        rating = try values.decodeIfPresent(Int.self, forKey: .rating)
        feedback = try values.decodeIfPresent(String.self, forKey: .feedback)
        errorCode = try values.decodeIfPresent(String.self, forKey: .errorCode)
        errorCodeDescription = try values.decodeIfPresent(String.self, forKey: .errorCodeDescription)
        files = try values.decodeIfPresent(Array.self, forKey: .files)
    }
    
}

