//
//  Account.swift
//  Gandalf
//
//  Created by Sean Hart on 2/5/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Account: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int // 0=blocked, 1=active
    var username: String?
    var created: Double?
    var tutorials: [String]?
    var email: String?
    var name: String?
    // Local
    var groupCount: Int = 0
    var messageCount: Int = 0
    var notionCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case username
        case created
        case tutorials
        case email
        case name
    }
}
