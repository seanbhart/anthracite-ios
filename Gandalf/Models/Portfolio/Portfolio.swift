//
//  Portfolio.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import Foundation

struct Portfolio {
    var brokerage: String
    var gains: Double
    var positions = [PortfolioPosition]()
    
    init(portfolio: [String: Any]) {
        self.brokerage = portfolio["brokerage"] as? String ?? "rh"
        self.gains = portfolio["gains"] as? Double ?? 0.0
        
        let positionsRaw = portfolio["positions"] as? [[String: Any]] ?? []
        self.positions = positionsRaw.compactMap { positionRaw -> PortfolioPosition in
            return PortfolioPosition(position: positionRaw)
        }
    }
}
