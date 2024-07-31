//
//  NewChatMessage.swift
//  ConnectMateCustomer
//
//  Created by macbook on 08/05/2023.
//

import Foundation


// MARK: - Welcome
struct NewChatMessage: Codable {
    var id : Int64 = 0
    var tempChatId : String?
    var customerId : Int64?
    var name : String?
    var cnic : String?
    var contactNo : String?
    var emailaddress : String?
    var sender : String?
    var agentId : Int64?
    var groupId : Int64?
    var message : String?
    var source : String?
    var conversationUId : String?
    var isResolved : Bool?
    var isWelcomeMessage : Bool?
    var connectionId : String?
    var isFromWidget : Bool?
    var ipAddress : String?
    var notifyMessage : String?
    var channelid : String?
    var type : String?
    var documentOrignalname : String?
    var documentName : String?
    var documentType : String?
    var mobileToken : String?
    var timezone : String?
    var caption : String?
    var fileUri : String?
    var topicId : Int64?
    var topicMessage : String?
    var createdOn : Date?
    var timestamp : String?
    var callerAppType : Int64?
}
