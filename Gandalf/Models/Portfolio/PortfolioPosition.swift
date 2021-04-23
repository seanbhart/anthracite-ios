//
//  PortfolioPositions.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import Foundation

struct PortfolioPosition {
    var symbol: String
    var cost: Double
    var price: Double
    var percCost: Double
    var percCurrent: Double
    
    init(position: [String: Any]) {
        self.symbol = position["symbol"] as? String ?? ""
        self.cost = position["cost"] as? Double ?? 0.0
        self.price = position["price"] as? Double ?? 0.0
        self.percCost = position["perc_cost"] as? Double ?? 0.0
        self.percCurrent = position["perc_current"] as? Double ?? 0.0
    }
}
