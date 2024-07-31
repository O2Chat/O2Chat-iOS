//
//  RecieveMessage.swift
//  ConnectMateCustomer
//
//  Created by macbook on 05/05/2023.
//

import Foundation
// MARK: - Welcome
struct RecieveMessage: Decodable {
    var id : Int64?
    var toUserId : Int64?
    var fromUserId : Int64?
    var groupId : Int64?
    var groupName : String?
    var tempChatId : String?
    var sender : String?
    var content : String?
    var type : String?
    var forwardedTo : Int64?
    var customerId : Int64?
    var customerName : String?
    var agentId : Int64?
    var receiver : String?
    var timestamp : String?
    var conversationUid : String?
    var isFromWidget : Bool?
    var isSeen : Bool?
    var isPrivate : Bool?
    var tiggerevent : Int64?
    var pageId : String?
    var pageName : String?
    var caption : String?
    //var createdOn : Date?
    var files : [FileDataModel]? = [FileDataModel]()


    enum CodingKeys: String, CodingKey {

        case id = "id"
        case toUserId = "toUserId"
        case fromUserId = "fromUserId"
        case groupId = "groupId"
        case groupName = "groupName"
        case tempChatId = "tempChatId"
        case sender = "sender"
        case content = "content"
        case type = "type"
        case forwardedTo = "forwardedTo"
        case customerId = "customerId"
        case customerName = "customerName"
        case agentId = "agentId"
        case receiver = "receiver"
        case timestamp = "timestamp"
        case conversationUid = "conversationUid"
        case isFromWidget = "isFromWidget"
        case isPrivate = "isPrivate"
        case tiggerevent = "tiggerevent"
        case pageId = "pageId"
        case pageName = "pageName"
        case caption = "caption"
        case files = "files"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int64.self, forKey: .id)
        toUserId = try values.decodeIfPresent(Int64.self, forKey: .toUserId)
        fromUserId = try values.decodeIfPresent(Int64.self, forKey: .fromUserId)
        groupId = try values.decodeIfPresent(Int64.self, forKey: .groupId)
        groupName = try values.decodeIfPresent(String.self, forKey: .groupName)
        tempChatId = try values.decodeIfPresent(String.self, forKey: .tempChatId)
        sender = try values.decodeIfPresent(String.self, forKey: .sender)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        forwardedTo = try values.decodeIfPresent(Int64.self, forKey: .forwardedTo)
        customerId = try values.decodeIfPresent(Int64.self, forKey: .customerId)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        agentId = try values.decodeIfPresent(Int64.self, forKey: .agentId)
        receiver = try values.decodeIfPresent(String.self, forKey: .receiver)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        conversationUid = try values.decodeIfPresent(String.self, forKey: .conversationUid)
        isFromWidget = try values.decodeIfPresent(Bool.self, forKey: .isFromWidget)
        isPrivate = try values.decodeIfPresent(Bool.self, forKey: .isPrivate)
        tiggerevent = try values.decodeIfPresent(Int64.self, forKey: .tiggerevent)
        pageId = try values.decodeIfPresent(String.self, forKey: .pageId)
        pageName = try values.decodeIfPresent(String.self, forKey: .pageName)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        files = try values.decodeIfPresent(Array.self, forKey: .files)
    }

}



