//
//  SymbolRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 5/4/21.
//

import FirebaseFirestore

protocol SymbolRepositoryDelegate {
    func symbolDataUpdate()
    func showLogin()
}

class SymbolRepository {
    var className = "SymbolRepository"
    
    var delegate: SymbolRepositoryDelegate?
    var symbols = [Symbol]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init() {
        query = Settings.Firebase.db().collection("tickers")
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
                
                symbols.removeAll()
                snapshot.documents.forEach { doc in
                    let docData = doc.data()
                    if let data = docData["data"] as? [String: Any] {
                        data.forEach { key, value in
//                            print("\(className) - symbol: \(key)")
                            if let symbolData = value as? [String: Any] {
                                let newSymbol = Symbol(symbol: key, name: symbolData["name"] as? String ?? "")
//                                print("\(className) - newSymbol: \(newSymbol)")
                                symbols.append(newSymbol)
                            }
                        }
                    }
                }
                
                if let parent = self.delegate {
                    parent.symbolDataUpdate()
                }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
}
