//
//  AccountSummaryRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import FirebaseFirestore

protocol PortfolioNameRepositoryDelegate {
    func accountsDataUpdate()
    func showLogin()
}

class PortfolioNameRepository {
    var className = "AccountSummaryRepository"
    
    var delegate: AccountSummaryRepositoryDelegate?
    var accounts = [AccountSummary]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init() {
        query = Settings.Firebase.db().collection("accounts")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()

        listener = query
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error {
                    if let parent = self.delegate {
                        print("\(className) - LISTENER ERROR: \(err)")
                        parent.showLogin()
                    }
                }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                
                self.accounts.removeAll()
                self.accounts = snapshot.documents.compactMap { doc -> AccountSummary? in
                    var aSummary = try? doc.data(as: AccountSummary.self)
                    let accountDataRaw = doc.data()
                    aSummary?.portfolio = Portfolio(portfolio: accountDataRaw["portfolio"] as? [String: Any] ?? [:])
                    
                    let shadowingsRaw = accountDataRaw["shadowing"] as? [[String: Any]] ?? []
                    aSummary?.shadowing = shadowingsRaw.compactMap { shadowingRaw -> AccountShadowing in
                        return AccountShadowing(shadowing: shadowingRaw)
                    }
//                    print("\(className) - aSummary: \(String(describing: aSummary))")
                    return aSummary
                }
                
                if let parent = self.delegate {
                    parent.accountsDataUpdate()
                }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
}
