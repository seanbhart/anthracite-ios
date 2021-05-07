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
    var reactions: [StrategyReaction]?
    var windowExpiration: Double
    var version: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case caption
        case created
        case creator
        case orders
        case windowExpiration = "window_expiration"
        case version
    }
    
    init(creator: String, windowExpiration: Double) {
        self.creator = creator
        self.windowExpiration = windowExpiration
        self.created = Date().timeIntervalSince1970 * 1000
        self.orders = [StrategyOrder]()
        self.version = "v3.0.0"
    }
    
    // The Created timestamp should be passed in milliseconds
    static func ageString(timestamp: Double) -> String {
        let timestampSec = timestamp / 1000
        let ageMins = (Date().timeIntervalSince1970 - timestampSec) / 60
        if (ageMins < 1) {
            return "just now"
        } else if (Int(ageMins) == 1) {
            return " 1 min ago"
        } else if (ageMins < 60) {
            return "\(Int(ageMins)) mins ago"
        } else if (Int(round(ageMins / 60)) == 1) {
            return "1 hr ago"
        } else if (Int(round(ageMins / 60)) > 1 && ageMins < 60*24) {
            return "\(Int(round(ageMins / 60))) hrs ago"
        } else {
            return timestampToDatetimeLocal(timestamp: timestamp)
        }
    }
    
    static func secondsRemainToString(seconds: Int) -> String {
        if (seconds == 3600 * 24) {
            return "1 DAY"
        } else if (seconds > 3600 * 24) {
//            return String(format: "%d DAYS, %02d HRS", seconds / (3600 * 24), (seconds / 3600))
            return "\(round((Double(seconds) / (3600 * 24)) * 10) / 10) DAYS"
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
    var symbol: String?
    var type: Int
    
    enum CodingKeys: String, CodingKey {
        case direction
        case expiration
        case predictPriceDirection = "predict_price_direction"
        case price
        case symbol
        case type
    }
    
    init(direction: Int, predictPriceDirection: Int, type: Int) {
        self.direction = direction
        self.predictPriceDirection = predictPriceDirection
        self.type = type
    }
}
