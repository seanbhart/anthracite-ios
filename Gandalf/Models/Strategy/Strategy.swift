//
//  Strategy.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Strategy: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int?
    var created: Double
    var creator: String
    var orders: [StrategyOrder]
    var reactions: StrategyReactions
    var windowMins: Double
    var version: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case created
        case creator
        case orders
        case reactions
        case windowMins = "window_mins"
        case version
    }
}

struct StrategyOrder: Codable {
    var direction: Int
    var expiration: Double?
    var predictPriceDirection: Int
    var price: Double?
    var symbol: String
    var type: Int
    
    enum CodingKeys: String, CodingKey {
        case direction
        case expiration
        case predictPriceDirection = "predict_price_direction"
        case price
        case symbol
        case type
    }
}

struct StrategyReactions: Codable {
    var dislike: Int
    var like: Int
    var ordering: Int

    enum CodingKeys: String, CodingKey {
        case dislike
        case like
        case ordering
    }
}
