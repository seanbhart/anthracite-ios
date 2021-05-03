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
    var caption: String?
    var created: Double
    var creator: String
    var orders: [StrategyOrder]
    var reactions: StrategyReactions
    var windowSecs: Double
    var version: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case caption
        case created
        case creator
        case orders
        case reactions
        case windowSecs = "window_secs"
        case version
    }
    
    static func ageString(timestamp: Double) -> String {
        let timestampSec = timestamp / 1000
        let ageMins = (Date().timeIntervalSince1970 - timestampSec) / 60
        if (ageMins < 60) {
            return "\(ageMins) mins ago"
        } else if (ageMins > 60 && ageMins < 60*24) {
            return "\(((ageMins / 60) * 10).rounded() / 10) hrs ago"
        } else {
            return timestampToDatetimeLocal(timestamp: timestamp)
        }
    }
    
    static func secondsRemainToString(seconds: Int) -> String {
        if (seconds > 3600 * 24) {
            return String(format: "%02d DAYS, %02d HRS", seconds / (3600 * 24), (seconds / 3600))
        } else {
            return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
    }
//    static func windowMinsString(windowMins: Double) -> String {
//        if (windowMins < 60) {
//            return "\(windowMins) MINS"
//        } else if (windowMins > 60 && windowMins < 60*24) {
//            return "\(((windowMins / 60) * 10).rounded() / 10) HRS"
//        } else if (windowMins > 60*24) {
//            return "\(((windowMins / (60*24)) * 10).rounded() / 10) DAYS"
//        } else {
//            return "\(windowMins / 60) HRS"
//        }
//    }
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

struct Order {
    
    enum Direction: Int {
        case SELL = 0
        case BUY = 1
    }
    static func directionFrom(int: Int) -> Direction {
        switch int
        {
        case 0:
            return Direction.SELL
        case 1:
            return Direction.BUY
        default:
            return Direction.BUY
        }
    }
    static func directionToString(direction: Int) -> String {
        switch direction {
        case 0:
            return "SELL"
        case 1:
            return "BUY"
        default:
            return "BUY"
        }
    }
    
    enum OrderType: Int {
        case MARKET = 0
        case LIMIT = 1
        case CALL = 2
        case PUT = 3
    }
    static func typeFrom(int: Int) -> OrderType {
        switch int
        {
        case 0:
            return OrderType.MARKET
        case 1:
            return OrderType.LIMIT
        case 2:
            return OrderType.CALL
        case 3:
            return OrderType.PUT
        default:
            return OrderType.MARKET
        }
    }
    static func typeToString(type: Int) -> String {
        switch type {
        case 0:
            return "MARKET"
        case 1:
            return "LIMIT"
        case 2:
            return "CALL"
        case 3:
            return "PUT"
        default:
            return "ORDER"
        }
    }
}
