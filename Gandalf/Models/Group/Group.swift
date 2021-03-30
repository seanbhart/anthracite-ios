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
    var manager: String
    var members: [String]
    var memberMetadata: [String:String] //keys: vote, funds
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case created
        case creator
        case manager
        case members
        case memberMetadata = "members_metadata"
        case name
    }
}
