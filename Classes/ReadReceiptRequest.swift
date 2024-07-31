//
//  ReadReceiptRequest.swift
//  ConnectMateCustomer
//
//  Created by macbook on 07/07/2023.
//

import Foundation

struct ReadReceiptRequest: Codable {
    var conversationUId : String?
    var id : Int64?
    var conversationDetailId : Int64?
    var isSeen : Bool?
    var callerAppType : Int64?
}
