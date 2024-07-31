//
//  ConversationsByUUID.swift
//  ConnectMateCustomer
//
//  Created by macbook on 15/05/2023.
//

import Foundation
// MARK: - Welcome
struct ConversationsByUUID : Codable {
    var id : Int64 = 0
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
    var tiggerevent : Int64?
    var customerName : String?
    var conversationUid : String?
    var isAgentReplied : Bool?
    var isResolved : Bool?
    var isFromWidget : Bool? = false
    var isPrivate : Bool?
    var childConversationCount : Int64?
    var conversationType : String?
    var pageId : String?
    var pageName : String?
    var base64Image : String? = ""
    var fileLocalUri : String?
    var isRecordUpdated : Bool?
    var isNewMessageReceive : Bool?
    var isDownloading : Bool?
    var isSeen : Bool?
    var isUpdateStatus : Bool?
    var isShowLocalFiles : Bool?
    var isNotNewChat : Bool?
    var isWelcomeMessage : Bool?
    var caption : String?
    var isFailed : Bool? = false
    var isReceived : Bool? = false
    var topicId : Int64?
    var createdOn : Date?
    var topicMessage : String?
    var rating : Int?
    var feedback : String?
    var isFeedback : Bool?
    var files : [FileDataModel]?
}

struct QueueConversationModel : Codable {
    var listConversationVM : [ConversationsByUUID]?
    
}

struct BulkConversationModel : Codable {
    var conversationVMList : [ConversationsByUUID] = [ConversationsByUUID]()
    
}

