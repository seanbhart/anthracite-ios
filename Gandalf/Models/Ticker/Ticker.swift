//
//  Ticker.swift
//  Gandalf
//
//  Created by Sean Hart on 1/28/21.
//

import UIKit

struct Ticker {
    var ticker: String!
    var responseCount: Int = 0
    var wAvgSentiment: Float = 0
    var wAvgMagnitude: Float = 0
    var selected: Bool = false
    
    init(ticker: String) {
        self.ticker = ticker
    }
    init(ticker: String, responseCount: Int) {
        self.ticker = ticker
        self.responseCount = responseCount
    }
    init(ticker: String, responseCount: Int, wAvgSentiment: Float, wAvgMagnitude: Float) {
        self.ticker = ticker
        self.responseCount = responseCount
        self.wAvgSentiment = wAvgSentiment
        self.wAvgMagnitude = wAvgMagnitude
    }
}
