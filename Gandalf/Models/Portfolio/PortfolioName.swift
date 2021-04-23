//
//  AccountSummary.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import Foundation
import FirebaseFirestoreSwift

struct PortfolioName: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int?
    var account: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case account
        case name
    }
}
