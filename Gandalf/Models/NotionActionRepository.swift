//
//  NotionActionRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/1/21.
//

import FirebaseAuth
import FirebaseFirestore

protocol NotionActionRepositoryDelegate {
    func notionActionDataUpdate()
}

class NotionActionRepository {
    var className = "NotionActionRepository"
    
    var delegate: NotionActionRepositoryDelegate?
    var recency: Double! //seconds
    var notionActions = [NotionAction]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init(recency: Double) {
        self.recency = recency
        query = Settings.Firebase.db().collection("notion_action")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        guard let firUser = Auth.auth().currentUser else { return }
        stopObserving()
        
        // Listen for NotionAction for the signed in account in the same time period
        // as the listener for Notions
        listener = query
            .whereField("status", isEqualTo: 1)
            .whereField("account", isEqualTo: firUser.uid)
            .whereField("timestamp", isGreaterThan: Date().timeIntervalSince1970 - recency)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error { print("\(className) - LISTENER ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                
                self.notionActions.removeAll()
                self.notionActions = snapshot.documents.compactMap { queryDocumentSnapshot -> NotionAction? in
                    return try? queryDocumentSnapshot.data(as: NotionAction.self)
                }
                
                if let parent = self.delegate {
                    parent.notionActionDataUpdate()
                }
            }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
    
    // Create or update an action on a specific notion
    func addSentimentAction(notion: String, quantity: Int) {
        guard let firUser = Auth.auth().currentUser else { return }
        
        // First query for any existing actions on this Notion for this Account
        Settings.Firebase.db().collection("notion_action")
            .whereField("type", isEqualTo: "sentiment")
            .whereField("account", isEqualTo: firUser.uid)
            .whereField("notion", isEqualTo: notion)
            .getDocuments(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - getDocuments ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) getDocuments snapshot error: \(error!)"); return }
                
                let returnedNotionActions = snapshot.documents.compactMap { queryDocumentSnapshot -> NotionAction? in
                    return try? queryDocumentSnapshot.data(as: NotionAction.self)
                }
                
                // There should only be one document with this query combo (if any),
                // so use the first one, otherwise create a new document
                if returnedNotionActions.count > 0 {
                    // Get the current quantity amount and adjust by the passed quantity
                    // up to the max (should not have been passed if at max anyway)
                    // If the status is 0, pretend the quantity on the doc is 0 (was ignored anyway)
                    var newQuantity = returnedNotionActions[0].quantity + quantity
                    if returnedNotionActions[0].status == 0 {
                        newQuantity = quantity
                    }
                    if newQuantity > abs(Settings.sentimentAdjMaxActions) { return }
                    Settings.Firebase.db().collection("notion_action").document(snapshot.documents[0].documentID).setData([
                        "quantity": newQuantity,
                        "status": NSNumber(value: 1)
                    ], merge: true) { err in
                        if let err = err {
                            print("\(self.className) - FIREBASE: ERROR update sentiment action: \(err)")
                        } else {
                            print("\(self.className) - FIREBASE: sentiment action successfully updated")
                        }
                    }
                    
                } else {
                    // Create a new document
                    Settings.Firebase.db().collection("notion_action").document().setData([
                        "account": firUser.uid,
                        "notion": notion,
                        "quantity": quantity,
                        "status": NSNumber(value: 1),
                        "timestamp": Date().timeIntervalSince1970,
                        "type": "sentiment"
                    ], merge: true) { err in
                        if let err = err {
                            print("\(self.className) - FIREBASE: ERROR creating sentiment action: \(err)")
                        } else {
                            print("\(self.className) - FIREBASE: sentiment action successfully created")
                        }
                    }
                }
            })
        
        
    }
}
