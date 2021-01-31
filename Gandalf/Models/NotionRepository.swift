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
    func getLocalTickers() -> [Ticker]
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
                    let responseCount = self.notions
                        .filter({ $0.tickers.compactMap({ $0 }).contains(t) })
                        .map({ $0.responseCount })
                        .reduce(0, +)
                    let wAvgSentiment = self.notions
                        .filter({ $0.tickers.compactMap({ $0 }).contains(t) })
                        .map({ $0.sentiment })
                        .reduce(0, +) / Float(responseCount)
                    let wAvgMagnitude = self.notions
                        .filter({ $0.tickers.compactMap({ $0 }).contains(t) })
                        .map({ $0.magnitude })
                        .reduce(0, +) / Float(responseCount)
                    
                    // Filter the data so no long tickers appear in the list
                    // and any remove any ticker with less than 5 appearances
                    if t.count < 5 && responseCount > 4 {
                        self.tickers.append(Ticker(ticker: t, responseCount: responseCount, wAvgSentiment: wAvgSentiment, wAvgMagnitude: wAvgMagnitude))
                    }
                    // WARNING: Filtering out Tickers below a response count threshold could remove Notions
                    // that also belong to Tickers above the threshold, causing discrepancies to show between
                    // the Ticker summary count and the Notion summary count in the view.
                }
                
                var selectedTickers = [Ticker]()
                // but save the currently selected Tickers to update the new list
                if let parent = self.repoDelegate {
                    selectedTickers = parent.getLocalTickers().filter({ $0.selected })
                }
                // Set tickers in the new list to selected if they were previously
                // selected (if they exist in the new list). However, don't replace
                // the new Ticker with the old one - the response count will not update.
                self.tickers = self.tickers.map({
                    var t = $0
                    if selectedTickers.filter({ $0.ticker == t.ticker }).count > 0 {
                        t.selected = true
                        return t
                    } else {
                        return $0
                    }
                })
                
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
