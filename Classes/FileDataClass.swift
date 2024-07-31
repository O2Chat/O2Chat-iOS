//
//  FileDataClass.swift
//  ConnectMateCustomer
//
//  Created by macbook on 15/05/2023.
//

import Foundation
// MARK: - Welcome
struct FileDataClass: Codable {
    var fileName : String?
    var fileSizes : String?
    var mimeType : String?
    var url : String?
    var tempChatId : String?
    var fileLocalUri : String?
    var message : String?
}
