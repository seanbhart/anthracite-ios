//
//  NotionRepository.swift
//  Alatar
//
//  Created by Sean Hart on 1/27/21.
//

import FirebaseFirestore

protocol RepositoryDelegate {
    func dataUpdate()
}

class NotionRepository {
    var repoDelegate: RepositoryDelegate?
    var ticker: String!
    var recency: Double! //seconds
    var notions = [Notion]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init(ticker: String, recency: Double) {
        self.ticker = ticker
        self.recency = recency
        query = Settings.Firebase.db().collection("notion")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        let timestamp = Date().timeIntervalSince1970 - recency
        print(timestamp)

        listener = query
            .whereField("created", isGreaterThan: timestamp)
            .whereField("tickers", arrayContains: ticker!)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                guard let snapshot = snapshot else { print("snapshot error: \(error!)"); return }
//                guard let documents = snapshot.documents else { print("No documents"); return }
                
                self.notions = snapshot.documents.compactMap { queryDocumentSnapshot -> Notion? in
                    return try? queryDocumentSnapshot.data(as: Notion.self)
                }
                print(self.notions.count)
                self.notions.sort(by: { $0.created > $1.created })
                if let parent = self.repoDelegate {
                    parent.dataUpdate()
                }
        }
    }

    func stopObserving() {
        listener?.remove()
    }
}
