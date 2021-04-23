//
//  AccountShadowing.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import Foundation

struct AccountShadowing {
    var target: String
    var started: TimeInterval
    
    init(shadowing: [String: Any]) {
        self.target = shadowing["target"] as? String ?? ""
        self.started = shadowing["started"] as? TimeInterval ?? Date().timeIntervalSince1970
    }
}
