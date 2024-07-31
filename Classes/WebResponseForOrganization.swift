//
//  WebResponseForOrganization.swift
//  ConnectMateCustomer
//
//  Created by macbook on 15/06/2023.
//

import Foundation

struct WebResponseForOrganization: Decodable {
    var isSuccess : Bool?
    var message : String?
    var id : Int?
    var result : OrganizationData?
  
        

    enum CodingKeys: String, CodingKey {

        case isSuccess = "isSuccess"
        case message = "message"
        case result = "result"
        case id = "id"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try values.decodeIfPresent(Bool.self, forKey: .isSuccess)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        result = try values.decodeIfPresent(OrganizationData.self, forKey: .result)
        id = try values.decodeIfPresent(Int.self, forKey: .id)

    }
    

}


