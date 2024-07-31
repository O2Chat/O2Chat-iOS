//
//  WebResponseConversationByUUID.swift
//  ConnectMateCustomer
//
//  Created by macbook on 17/05/2023.
//

import Foundation
// MARK: - Welcome
struct WebResponseConversationByUUID: Decodable {
    var isSuccess : Bool?
    var message : String?
    var id : Int?
    var pageSize : Int?
    var pageNumber : Int?
    var totalPages : Int?
    var totalRecords : Int?
    var result : [ConversationsByUUID]?
  
        

    enum CodingKeys: String, CodingKey {

        case isSuccess = "isSuccess"
        case message = "message"
        case result = "result"
        case id = "id"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
        case totalPages = "totalPages"
        case totalRecords = "totalRecords"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try values.decodeIfPresent(Bool.self, forKey: .isSuccess)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        result = try values.decodeIfPresent(Array.self, forKey: .result)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        pageNumber = try values.decodeIfPresent(Int.self, forKey: .pageNumber)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        totalRecords = try values.decodeIfPresent(Int.self, forKey: .totalRecords)

    }
    

}


