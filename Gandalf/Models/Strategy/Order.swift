//
//  Order.swift
//  Gandalf
//
//  Created by Sean Hart on 5/6/21.
//

import Foundation

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
