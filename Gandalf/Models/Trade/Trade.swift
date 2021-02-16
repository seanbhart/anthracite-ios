//
//  Trade.swift
//  Gandalf
//
//  Created by Sean Hart on 2/15/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Trade: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int?
    var group: String
    var creator: String
    var ticker: String
    var position: String
    var value: Double
    var simulated: Bool = true

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case group
        case creator
        case ticker
        case position
        case value
        case simulated
    }
}
