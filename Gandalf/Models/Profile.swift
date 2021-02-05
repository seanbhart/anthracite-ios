//
//  Profile.swift
//  Gandalf
//
//  Created by Sean Hart on 2/5/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Profile: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int
    var timestamp: Float
    var email: String
    var name: [String:String]?
//    var settings: [String:String]?
    var username: String?
    // Local
    var groupCount: Int = 0
    var messageCount: Int = 0
    var notionCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case timestamp
        case email
        case name
//        case settings
        case username
    }
}
