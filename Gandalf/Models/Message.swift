//
//  Message.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int
    var account: String
    var timestamp: TimeInterval
    var text: String
    var tickers: [String]?
    // Local
    var group: String?

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case account
        case timestamp
        case text
        case tickers
    }
}
