//
//  TypingIndicatorListenerModel.swift
//  ConnectMateCustomer
//
//  Created by macbook on 19/07/2023.
//

import Foundation

struct TypingIndicatorListenerModel: Codable {
    var conversationUId : String = ""
    var name : String = ""
    var id : Int64 = 0
    
    var callerAppType : Int64?
}
