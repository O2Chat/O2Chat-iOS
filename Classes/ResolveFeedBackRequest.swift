//
//  ResolveFeedBackRequest.swift
//  Befiler
//
//  Created by Sanjay Kumar on 31/01/2024.
//  Copyright © 2024 Haseeb. All rights reserved.
//

import Foundation
struct ResolveFeedBackRequest: Codable {
    
    var conversationUid: String = ""
    var feedback: String = ""
    var callerAppType: Int = 0
    var rating: Int = 0
    var isSatisfied: Bool = false
    
}
