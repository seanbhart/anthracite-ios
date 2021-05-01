//
//  StrategyRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import FirebaseFirestore

protocol StrategyRepositoryDelegate {
    func strategyDataUpdate()
    func showLogin()
}

class StrategyRepository {
    var className = "StrategyRepository"
    
    var delegate: StrategyRepositoryDelegate?
    var strategies = [Strategy]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init() {
        query = Settings.Firebase.db().collection("strategies")
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
                
                strategies.removeAll()
                strategies = snapshot.documents.compactMap { queryDocumentSnapshot -> Strategy? in
//                    print("\(className) - strategy: \(queryDocumentSnapshot.data())")
                    return try? queryDocumentSnapshot.data(as: Strategy.self)
                }
                
                if let parent = self.delegate {
                    parent.strategyDataUpdate()
                }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
}

