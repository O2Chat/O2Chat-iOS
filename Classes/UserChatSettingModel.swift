//
//  UserChatSettingModel.swift
//  befiler
//
//  Created by macbook on 24/07/2023.
//  Copyright © 2023 Haseeb. All rights reserved.
//

import Foundation
struct UserChatSettingModel: Codable {
    let customerId: String?
    let conversionUUID: String?
    
    init(customerId: String?, conversionUUID: String?) {
        self.customerId = customerId
        self.conversionUUID = conversionUUID
     
    }
}
