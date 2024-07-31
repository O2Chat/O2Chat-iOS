//
//  UploadFilesData.swift
//  ConnectMateCustomer
//
//  Created by macbook on 14/05/2023.
//

import Foundation

struct UploadFilesData: Codable {
    
    var documentOrignalName : String?
    var documentName : String?
    var documentType : String?
    
 
}

struct UploadFilesDataNew: Codable {
    
    var tempChatID : String?
    var file : String?
    var fileName : String?
    var contentType : String?
 
}

struct WebResponseNew<T: Codable>: Codable {
    // Define properties based on your model
    var uploadFilesData : UploadFilesData?
}

struct MultiFilesResponseModel: Codable {
    let id: Int?
    let isSuccess: Bool?
    let message: String?
    let result : [UploadNewFilesData]?
}

struct UploadNewFilesData: Codable {

    var documentName : String?
    var documentType : String?
    var tempChatId : String?
    var documentOrignalName : String?
    var caption : String?
//    var errorCode: Int?
 
}


