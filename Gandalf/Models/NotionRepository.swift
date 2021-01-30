//
//  NotionRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import FirebaseFirestore

protocol RepositoryDelegate {
    func dataUpdate()
    func showLogin()
}

class NotionRepository {
    var repoDelegate: RepositoryDelegate?
    var recency: Double! //seconds
    var notions = [Notion]()
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
                if let err = error {
                    if let parent = self.repoDelegate {
                        print(err)
                        parent.showLogin()
                    }
                }
                guard let snapshot = snapshot else { print("snapshot error: \(error!)"); return }
                
                self.notions.removeAll()
                self.notions = snapshot.documents.compactMap { queryDocumentSnapshot -> Notion? in
                    return try? queryDocumentSnapshot.data(as: Notion.self)
                }
                
                // Create a list of all tickers in the data
                let tickerList = Set<String>(self.notions.flatMap({ $0.tickers.map({ $0 }) }))
                // Clear the ticker list and add new ticker summary data from the notions data
                self.tickers.removeAll()
                for t in tickerList {
                    let sum = self.notions.filter({ $0.tickers.compactMap({ $0 }).contains(t) }).map({ $0.responseCount }).reduce(0, +)
                    
                    // Filter the data so no long tickers appear in the list
                    // and any remove any ticker with less than 5 appearances
                    if t.count < 5 && sum > 4 {
                        self.tickers.append(Ticker(ticker: t, responseCount: sum))
                    } else if sum < 5 {
                        self.notions = self.notions.filter({ !$0.tickers.compactMap({ $0 }).contains(t) })
                    }
                }
                
//                print(self.notions.count)
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
