//
//  TradeRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/15/21.
//

import FirebaseFirestore

protocol TradeRepositoryDelegate {
    func tradeDataUpdate()
    func showLogin()
}

class TradeRepository {
    var className = "TradeRepository"
    
    var delegate: TradeRepositoryDelegate?
    var groupId: String!
    var trades = [Trade]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init(groupId: String) {
        self.groupId = groupId
        query = Settings.Firebase.db().collection("group").document(groupId).collection("trades")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()

        listener = query
            .whereField("status", isEqualTo: 1)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error { print("\(className) - LISTENER ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                
                trades.removeAll()
                trades = snapshot.documents.compactMap { queryDocumentSnapshot -> Trade? in
                    return try? queryDocumentSnapshot.data(as: Trade.self)
                }
                
                if let parent = self.delegate {
                    parent.tradeDataUpdate()
                }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
}

