//
//  Notion.swift
//  Alatar
//
//  Created by Sean Hart on 1/26/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Notion: Identifiable, Codable {
    @DocumentID var id: String?
    var host: String
    var hostId: String
    var text: String
    var created: Float
    var upvotes: Int = 0
    var downvotes: Int = 0
    var awardCount: Int = 0
    var responseCount: Int = 0
    var mediaLink: String?
    var categories: [String] = []
    var parent: String = ""
    var associated: [String] = []
    var sentiment: Float = 0.0
    var magnitude: Float = 0.0
    var tickers: [String] = []
    var confidence: Float = 0.0

    enum CodingKeys: String, CodingKey {
        case id
        case host
        case hostId = "host_id"
        case text
        case created
        case upvotes
        case downvotes
        case awardCount = "award_count"
        case responseCount = "response_count"
        case mediaLink = "media_link"
        case categories
        case parent
        case associated
        case sentiment
        case magnitude
        case tickers
        case confidence
    }
}
