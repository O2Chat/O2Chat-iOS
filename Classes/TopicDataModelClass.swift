//
//  TopicDataModelClass.swift
//  ConnectMateCustomer
//
//  Created by macbook on 06/07/2023.
//

import Foundation
struct TopicDataModelClass: Codable {
    var topicId : Int?
    var channelId : String?
    var groupId : Int64?
    var botId : Int?
    var name : String?
    var message : String?
    var profilePic : String?
    var isGroupAssigned : Bool?
    var topicVisibility : Int?
    var customText : String?
    var isTriggerBot : Bool?
    var botSchedule : Int?
    var isActive : Bool?
}
