//
//  ConversationStatusListenerDataModel.swift
//  Befiler
//
//  Created by Sanjay Kumar on 31/01/2024.
//  Copyright © 2024 Haseeb. All rights reserved.
//

import Foundation
struct ConversationStatusListenerDataModel: Codable {
    
    var agentName: String = ""
    var notifyMessage: String = ""
    var timestamp: String = ""
    var isResolved: Bool = false
    var conversationUid: String = ""
    var conversationId: Int64 = 0
    
}
