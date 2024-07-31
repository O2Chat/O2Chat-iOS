//
//  MultipartFormDataClass.swift
//  ConnectMateCustomer
//
//  Created by macbook on 26/05/2023.
//

import Foundation
// MARK: - Welcome
struct UploadFilesDataModel : Codable {
    var tempChatID : String?
    var file : String?
    var fileName : String?
    var contentType : String?
    var conversationUId : String?
    var caption : String?
}

struct files : Codable{
    var files : [UploadFilesDataModel] = [UploadFilesDataModel]()
}
