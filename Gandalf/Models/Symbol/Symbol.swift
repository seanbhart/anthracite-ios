//
//  Symbol.swift
//  Gandalf
//
//  Created by Sean Hart on 5/4/21.
//

import UIKit

struct Symbol {
    var symbol: String!
    var exchange: String?
    var name: String?
    var open: Double?
    var price: Double?
    var updated: Double?
    var updated_last_sale: Double?
    var updated_price: Double?
    var volume: Double?
    
    init(symbol: String) {
        self.symbol = symbol
    }
    init(symbol: String, name: String) {
        self.symbol = symbol
        self.name = name
    }
    init(symbol: String, exchange: String, name: String) {
        self.symbol = symbol
        self.exchange = exchange
        self.name = name
    }
}
