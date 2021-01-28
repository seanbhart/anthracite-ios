//
//  NotionRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import FirebaseFirestore

protocol RepositoryDelegate {
    func dataUpdate()
}

class NotionRepository {
    var repoDelegate: RepositoryDelegate?
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
    
    init(recency: Double) {
        self.recency = recency
        query = Settings.Firebase.db().collection("notion")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        let timestamp = Date().timeIntervalSince1970 - recency
        print(timestamp)

        // TODO: UPDATE QUERY FREQUENTLY (REFRESH TIMESTAMP CRITERIA)
        listener = query
            .whereField("created", isGreaterThan: timestamp)
//            .whereField("tickers", arrayContains: ticker!)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                guard let snapshot = snapshot else { print("snapshot error: \(error!)"); return }
                
                self.notions = snapshot.documents.compactMap { queryDocumentSnapshot -> Notion? in
                    return try? queryDocumentSnapshot.data(as: Notion.self)
                }
                print(self.notions.count)
                if let parent = self.repoDelegate {
                    parent.dataUpdate()
                }
        }
    }

    func stopObserving() {
        print("NotionRepository: stopObserving")
        listener?.remove()
    }
}
