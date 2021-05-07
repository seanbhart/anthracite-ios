//
//  StrategyReaction.swift
//  Gandalf
//
//  Created by Sean Hart on 5/6/21.
//

import Foundation
import FirebaseFirestoreSwift

struct StrategyReaction: Identifiable, Codable {
    @DocumentID var id: String?
    var status: Int
    var created: Double
    var creator: String?
    var strategy: String
    var type: Int

    enum CodingKeys: String, CodingKey {
        case status
        case created
        case creator
        case strategy = "strategy_id"
        case type
    }
    
    init(creator: String, strategy: String, type: Int) {
        self.status = 1
        self.created = Date().timeIntervalSince1970 * 1000
        self.creator = creator
        self.strategy = strategy
        self.type = type
    }
    init(creator: String, created: Double, status: Int, strategy: String, type: Int) {
        self.status = status
        self.created = created
        self.creator = creator
        self.strategy = strategy
        self.type = type
    }
}

struct StrategyReactionCount {
    var ordering: (account: Bool, total: Int)
    var up: (account: Bool, total: Int)
    var down: (account: Bool, total: Int)
    
    init(reactions: [StrategyReaction]) {
        guard let firUser = Settings.Firebase.auth().currentUser else { self.ordering = (false, 0); self.up = (false, 0); self.down = (false, 0); return }
        self.ordering = StrategyReactionCount.totalNetReactions(accountId: firUser.uid, reactions: reactions.filter { return $0.type == 0 })
        self.up = StrategyReactionCount.totalNetReactions(accountId: firUser.uid, reactions: reactions.filter { return $0.type == 1 })
        self.down = StrategyReactionCount.totalNetReactions(accountId: firUser.uid, reactions: reactions.filter { return $0.type == 2 })
    }
    
    // Should only pass reactions of a single type to properly calculate
    // Return a tuple with the first value a boolean indicating whether the passed user
    // has an odd number of reactions.
    static func totalNetReactions(accountId: String, reactions: [StrategyReaction]) -> (account: Bool, total: Int) {
        // Reaction actions are recorded per account for each reaction
        // If a single account created the same reaction multiple times, only
        // and odd number of that type of reaction should count as a reaction
        // to allow users to remove a past reaction. Count all accounts for
        // the passed reaction type that have an odd number of reactions.
        // Also return the net total reactions for the passed user, to determine
        // if that user is currently net positive for that reaction.
        
        // Create a set of all accounts
        let accounts = Set(reactions.map { $0.creator })
        var netReactions = 0
        accounts.forEach {
            let account = $0
            if reactions.filter({ $0.creator == account }).count % 2 != 0 { netReactions += 1 }
        }
        let accountReacted = reactions.filter({ $0.creator == accountId }).count % 2 != 0 ? true : false
        return (accountReacted, netReactions)
    }
}
