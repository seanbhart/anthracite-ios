//
//  AccountStrategyRespository.swift
//  Gandalf
//
//  Created by Sean Hart on 5/7/21.
//

import FirebaseFirestore

protocol AccountStrategyRepositoryDelegate {
    func strategyDataUpdate()
    func showLogin()
}

class AccountStrategyRepository {
    var className = "AccountStrategyRepository"
    
    var accountId: String!
    var delegate: AccountStrategyRepositoryDelegate?
    var strategies = [Strategy]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init(accountId: String) {
        print("\(className) - accountId: \(accountId)")
        self.accountId = accountId
        query = Settings.Firebase.db().collection("strategies").order(by: "created", descending: true)
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let accountId = accountId else { return }
        guard let query = query else { return }
        stopObserving()

        listener = query
            .whereField("creator", isEqualTo: accountId)
            .whereField("status", isEqualTo: 1)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error { print("\(className) - LISTENER ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                print("\(className) - account strategy doc count: \(snapshot.documents.count)")
                
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
