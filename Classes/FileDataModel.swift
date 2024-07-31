//
//  FileDataModel.swift
//  ConnectMateCustomer
//
//  Created by macbook on 05/05/2023.
//

import Foundation
// MARK: - Welcome
struct FileDataModel: Codable {
    var url : String?
    var type : String?
    var icon : String?
    var documentName : String?
    var documentOriginalName : String?
    var isLocalFile : Bool?
    var fileLocalUri : String?
    var caption : String?
 
}
