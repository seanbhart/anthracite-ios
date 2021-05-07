//
//  StrategyReactionsRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 5/5/21.
//

import FirebaseFirestore

protocol StrategyReactionRepositoryDelegate {
    func strategyReactionDataUpdate()
    func showLogin()
}

class StrategyReactionRepository {
    var className = "StrategyReactionRepository"
    
    var delegate: StrategyReactionRepositoryDelegate?
    var reactions = [StrategyReaction]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init() {
        query = Settings.Firebase.db().collection("strategy_reactions")
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
                
                reactions.removeAll()
                reactions = snapshot.documents.compactMap { queryDocumentSnapshot -> StrategyReaction? in
//                    print("\(className) - reaction: \(queryDocumentSnapshot.data())")
                    return try? queryDocumentSnapshot.data(as: StrategyReaction.self)
                }
                
                if let parent = self.delegate {
                    parent.strategyReactionDataUpdate()
                }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
    
    func createReaction(strategyId: String, type: Int) {
        print("\(className): createReaction")
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        
        Settings.Firebase.db().collection("strategy_reactions").document().setData([
            "created": Date().timeIntervalSince1970 * 1000,
            "creator": firUser.uid,
            "status": NSNumber(value: 1),
            "strategy_id": strategyId,
            "type": NSNumber(value: type),
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR creating Strategy: \(err)")
//                if let parent = self.delegate {
//                    parent.requestError(message: "We're sorry, there was a problem creating the Strategy. Please try again.")
//                }
            } else {
                print("\(self.className) - FIREBASE: Strategy successfully created")
            }
        }
    }
}
