//
//  Settings.swift
//  Slate
//
//  Created by Sean Hart on 1/19/21.
//  Copyright © 2021 TangoJ Labs, LLC All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Settings {
    
    static var inBackground = false
    
    static var attemptedLogin: Bool = false
    static var serverTries: Int = 0 // Used to prevent looping through failed requests
    static var serverLastRefresh: TimeInterval = Date().timeIntervalSince1970 // Used to prevent looping through failed requests in a short period of time
    static var lastCredentials: TimeInterval = Date().timeIntervalSince1970
    
    struct Firebase {
        static let settings = { () -> FirestoreSettings in
            let settings = FirestoreSettings()
            settings.isPersistenceEnabled = true
            settings.isSSLEnabled = true
            return settings
        }
        static let db = { () -> Firestore in
            let settings = FirestoreSettings()
            settings.isPersistenceEnabled = true
            settings.isSSLEnabled = true
            let db = Firestore.firestore()
            db.settings = settings
            return db
        }
    }
}
