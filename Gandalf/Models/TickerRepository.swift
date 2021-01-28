//
//  TickerRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 1/28/21.
//

import FirebaseFirestore

class TickerRepository {
    var repoDelegate: RepositoryDelegate?
    var recency: Double! //seconds
    var tickers = [Ticker]()
    
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
        query = Settings.Firebase.db().collection("ticker")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        let timestamp = Date().timeIntervalSince1970 - recency
        print(timestamp)

        listener = query
            .whereField("latest_notion", isGreaterThan: timestamp)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                guard let snapshot = snapshot else { print("snapshot error: \(error!)"); return }
                
                self.tickers = snapshot.documents.compactMap { queryDocumentSnapshot -> Ticker? in
                    return try? queryDocumentSnapshot.data(as: Ticker.self)
                }
                print(self.tickers.count)
                
                
                self.tickers.sort(by: { $0.created > $1.created })
                if let parent = self.repoDelegate {
                    parent.dataUpdate()
                }
        }
    }

    func stopObserving() {
        listener?.remove()
    }
}
