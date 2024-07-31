//
//  RefreshTokenResponse.swift
//  O2ChatWidget
//
//  Created by Sanjay Kumar on 13/05/2024.
//

import Foundation

struct RefreshTokenResponse: Codable {
    
    var code: Int?
    var message: String? = ""
    var response : RefreshTokenResponseData = RefreshTokenResponseData()
    
    
}
    
struct RefreshTokenResponseData: Codable{
    var token: String?
    var tokenExpireDate: String?
    var refreshToken: String?
    var refreshTokenExpireDate: String?

}
