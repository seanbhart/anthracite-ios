//
//  Shadow.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Shadow: Identifiable, Codable {
    @DocumentID var id: String?
    var target: String?
    var timestamp: Int?
    var type: String?
    var valueStart: Double?
    var symbols = [String]()
    var positions = [ShadowPosition]()

    enum CodingKeys: String, CodingKey {
        case id
        case target
        case timestamp
        case type
        case valueStart = "value_start"
        case symbols
    }
}
