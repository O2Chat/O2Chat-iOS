//
//  TopicDataModel.swift
//  ConnectMateCustomer
//
//  Created by macbook on 12/06/2023.
//

import Foundation
// MARK: - Welcome
struct TopicDataModel: Codable {
    var status : Bool?
    var topicList : [TopicDataModelClass] = [TopicDataModelClass]()
}


