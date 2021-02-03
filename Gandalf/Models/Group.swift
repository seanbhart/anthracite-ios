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
    var created: Float
    var creator: String
    var members: [String]
    var title: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case created
        case creator
        case members
        case title
    }
}
