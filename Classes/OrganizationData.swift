//
//  OrganizationData.swift
//  ConnectMateCustomer
//
//  Created by macbook on 15/06/2023.
//

import Foundation

struct OrganizationData: Codable {
    var id : Int?
    var orgName : String?
    var email : String?
    var phone : String?
    var address : String?
    var displayname : String?
    var timezone : String?
    var errorCode : Int?
}
