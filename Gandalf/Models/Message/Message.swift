//
//  Message.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import Foundation
import FirebaseFirestoreSwift

struct MessageGandalf: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int
    var account: String
    var timestamp: TimeInterval
    var text: String
    var tickerDicts: [[String:String]]?
    var tickerSentiment: [String:Double]? //[AccountId: SentimentValue]
    var reactions: [String:String]? //[AccountId: ReactionId]
    // Local
    var group: String?
    var tickers: [MessageTicker]?

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case account
        case timestamp
        case text
        case tickerDicts = "tickers"
        case tickerSentiment = "ticker_sentiment"
        case reactions
    }
    
    mutating func fillTickers() {
        if let tDicts = tickerDicts {
            if tDicts.count < 1 { return }
            tickers = [MessageTicker]()
            for tD in tDicts {
                var ticker = MessageTicker(ticker: tD["ticker"] ?? "")
                ticker.sentiment = MessageTicker.SentimentIndicator(rawValue: Int(tD["sentiment_indicator"] ?? "") ?? 0) ?? MessageTicker.SentimentIndicator.neutral
                tickers!.append(ticker)
            }
        }
        if let tSentiment = tickerSentiment {
            if tSentiment.count < 1 { return }
            tickers = [MessageTicker]()
            for tS in tSentiment {
                var ticker = MessageTicker(ticker: tS.key)
                ticker.sentiment = MessageTicker.SentimentIndicator(rawValue: Int(tS.value)) ?? MessageTicker.SentimentIndicator.neutral
                tickers!.append(ticker)
            }
        }
    }
}

struct MessageTicker {
    var ticker: String!
    var sentiment: SentimentIndicator = .neutral
    
    init(ticker: String) {
        self.ticker = ticker
    }
    
    enum SentimentIndicator: Int {
        case neutral
        case positive
        case negative
    }
    
    mutating func cycleSentiment() {
        switch sentiment {
        case .neutral:
            sentiment = .positive
        case .positive:
            sentiment = .negative
        case .negative:
            sentiment = .neutral
        }
    }
    
    func getSentimentMathValue() -> Int {
        switch sentiment {
        case .neutral:
            return 0
        case .positive:
            return 1
        case .negative:
            return -1
        }
    }
    
    func getSentimentColor() -> UIColor {
        switch sentiment {
        case .neutral:
            return Settings.Theme.Color.primary
        case .positive:
            return Settings.Theme.Color.positiveLight
        case .negative:
            return Settings.Theme.Color.negativeLight
        }
    }
}
