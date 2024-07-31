//
//  AuthSessionManager.swift
//  befiler
//
//  Created by apple on 20/10/2021.
//  Copyright © 2021 Haseeb. All rights reserved.
//

import Foundation
import Alamofire

class AuthSessionManager: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedUrlRequest = urlRequest
        adaptedUrlRequest.setValue(UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        completion(.success(adaptedUrlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("request \(request) failed")
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            guard let url = URL(string: "\(ApiClient.sheard.baseURL)/refresh") else { return }
            let paramet: Parameters = ["username":UserDefaults.standard.string(forKey: "refreshToken")!]
            AF.request(url, method: .post, parameters: paramet, encoding: JSONEncoding.default).validate().responseData { (response) in
                if let data = response.data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let loginResponse = try? decoder.decode(RefreshTokenResponse.self, from: data) {
                       
                        if(loginResponse.code == 1){
                            UserDefaults.standard.set(loginResponse.response.token!, forKey: "token")
                            UserDefaults.standard.set(loginResponse.response.tokenExpireDate!, forKey: "tokenExpireDate")
                            UserDefaults.standard.set(loginResponse.response.refreshToken ?? "", forKey: "refreshToken")
                            UserDefaults.standard.set(loginResponse.response.refreshTokenExpireDate!, forKey: "refreshTokenExpireDate")
                            UserDefaults.standard.synchronize()
                            completion(.retryWithDelay(1))
                        }
                        
                        
                    }
                }
            }
        }
    }

}
