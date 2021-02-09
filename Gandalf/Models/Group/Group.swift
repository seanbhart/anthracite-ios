//
//  Group.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int
    var created: Double
    var creator: String
    var lastActive: [String: Double]? // [account_id: timestamp]
    var lastViewed: [String: Double]? // [account_id: timestamp]
    var members: [String]
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case created
        case creator
        case lastActive = "last_active"
        case lastViewed = "last_viewed"
        case members
        case title
    }
}
