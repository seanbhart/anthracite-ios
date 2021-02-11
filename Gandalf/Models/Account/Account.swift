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
//    var timestamp: Float
//    var email: String
//    var name: [String:String]?
    var username: String?
    // Local
    var metadata: AccountMetadata?
    var pii: AccountPii?
    var settings: AccountSettings?
    var groupCount: Int = 0
    var messageCount: Int = 0
    var notionCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case status
//        case timestamp
//        case email
//        case name
        case username
    }
}

struct AccountMetadata: Identifiable, Codable {
    @DocumentID var id: String?
    var created: Double
    var tutorials: [String]?
}

struct AccountPii: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var name_given: String?
    var name_family: String?
}

struct AccountSettings: Identifiable, Codable {
    @DocumentID var id: String?
    var anonymous: Bool?
    var filter: Bool?
}
