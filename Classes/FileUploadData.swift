//
//  FileUploadData.swift
//  ConnectMateCustomer
//
//  Created by macbook on 29/05/2023.
//

import Foundation
// MARK: - Welcome
struct FileUploadData: Codable {
    var files : [String]?
    var type : String?
    var icon : String?
    var documentName : String?
    var isLocalFile : Bool?

}
