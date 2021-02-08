//
//  NotionAction.swift
//  Gandalf
//
//  Created by Sean Hart on 2/1/21.
//

import Foundation
import FirebaseFirestoreSwift

struct NotionAction: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int = 1
    var type: String
    var timestamp: Float
    var account: String
    var notion: String
    var quantity: Int

    enum CodingKeys: String, CodingKey {
        case status
        case type
        case timestamp
        case account
        case notion
        case quantity
    }
}
