//
//  Settings.swift
//  Slate
//
//  Created by Sean Hart on 1/19/21.
//  Copyright © 2021 TangoJ Labs, LLC All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Settings {
    
    static let debug = false
    static let currentTutorial = "v3.0.0"
    
    struct Tabs {
        static let strategyVcIndex = 0
        static let accountVcIndex = 1
    }
    
    static var inBackground = false
    
    static var attemptedLogin: Bool = false
    static var serverTries: Int = 0 // Used to prevent looping through failed requests
    static var serverLastRefresh: TimeInterval = Date().timeIntervalSince1970 // Used to prevent looping through failed requests in a short period of time
    static var lastCredentials: TimeInterval = Date().timeIntervalSince1970
    
    static let sentimentAdjAmt: Float = 0.25
    static let sentimentAdjMaxActions: Int = 4 //Max adjustment actions in one direction
    
    struct Firebase {
//        static let storageBucketAccounts = "gs://gandalf-accounts"
        
//        static let settings = { () -> FirestoreSettings in
//            let settings = FirestoreSettings()
//            settings.isPersistenceEnabled = true
//            settings.isSSLEnabled = true
//            return settings
//        }
        static let db = { () -> Firestore in
            let settings = FirestoreSettings()
            if Settings.debug {
                settings.host = "localhost:8080"
            }
            settings.isPersistenceEnabled = true
            settings.isSSLEnabled = true
            let db = Firestore.firestore()
            db.settings = settings
            return db
        }
        static let auth = { () -> Auth in
            let auth = Auth.auth()
            if Settings.debug {
                auth.useEmulator(withHost: "localhost", port: 9099)
            }
            return auth
        }
    }
    
    static func formatDateString(timestamp: TimeInterval) -> String {
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "h:mm a"
        format.amSymbol = "AM"
        format.pmSymbol = "PM"
        
        // Format the date based on the current time
        let currentTimestamp = Date().timeIntervalSince1970
        // Less than a day, just show the time
        if currentTimestamp - timestamp <= (60*60*24) {
            format.dateFormat = "h:mm a"
            return format.string(from: Date(timeIntervalSince1970: Double(timestamp)))
        } else {
            format.dateFormat = "MMM d  h:mm a"
            return format.string(from: Date(timeIntervalSince1970: Double(timestamp)))
        }
    }
}
