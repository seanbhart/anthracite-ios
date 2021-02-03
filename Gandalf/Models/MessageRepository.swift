//
//  MessageRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import FirebaseAuth
import FirebaseFirestore

protocol MessageRepositoryDelegate {
    func messageDataUpdate()
    func getLocalTickers() -> [Ticker]
}

class MessageRepository {
    var className = "MessageRepository"
    
    var delegate: MessageRepositoryDelegate?
    var group: String!
    var messages = [Message]()
    var accountNames = [String: String]()
    var tickers = [Ticker]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init(group: String) {
        self.group = group
        query = Settings.Firebase.db().collection("group").document(group).collection("messages")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        // Listen for Messages added to this group
        listener = query
            .whereField("status", isEqualTo: 1)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error { print("\(className) - LISTENER ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                
                self.messages.removeAll()
                self.messages = snapshot.documents.compactMap { queryDocumentSnapshot -> Message? in
                    return try? queryDocumentSnapshot.data(as: Message.self)
                }
                // Query for the display names of all message senders
                for m in messages {
                    self.getAccountDisplayName(account: m.account)
                }
                
                // Clear the ticker list and add new ticker summary data
                self.tickers.removeAll()
                let tickerStringsAll = self.messages.compactMap({ $0.tickers?.map({ $0 }) }).reduce([], +)
                let tickerOccurrences = tickerStringsAll.reduce(into: [:]) { $0[$1, default: 0] += 1 }
                for ticker in tickerOccurrences {
                    self.tickers.append(Ticker(ticker: ticker.key, responseCount: ticker.value))
                }
                
                var selectedTickers = [Ticker]()
                // but save the currently selected Tickers to update the new list
                if let parent = self.delegate {
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
                print("snapshot listener")
                if let parent = self.delegate {
                    parent.messageDataUpdate()
                }
            }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
    
    func createMessage(text: String, tickers: [String]) {
        if text == "" { return }
        guard let firUser = Auth.auth().currentUser else { return }
        
        Settings.Firebase.db().collection("group").document(group).collection("messages").document().setData([
            "account": firUser.uid,
            "status": NSNumber(value: 1),
            "text": text,
            "tickers": tickers,
            "timestamp": Date().timeIntervalSince1970,
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR creating message: \(err)")
            } else {
                print("\(self.className) - FIREBASE: message successfully created")
            }
        }
    }
    
    func deleteMessage(id: String?) {
        guard let id = id else { return }
        Settings.Firebase.db().collection("group").document(group).collection("messages").document(id).setData([
            "status": NSNumber(value: 0),
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR deleting message: \(err)")
            } else {
                print("\(self.className) - FIREBASE: message successfully deleting")
            }
        }
    }
    
    func getAccountDisplayName(account: String) {
        Settings.Firebase.db().collection("accounts").document(account)
            .getDocument(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - getAccountDisplayName ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) getAccountDisplayName snapshot error: \(error!)"); return }
                
                let sData = snapshot.data()
                guard let data = sData else { return }
                guard let name = data["name"] as? [String: String] else { return }
                guard let givenName = name["given"] else { return }
                guard let familyName = name["family"] else { return }
                self.accountNames[account] = givenName + " " + familyName
                
                if let parent = self.delegate {
                    parent.messageDataUpdate()
                }
            })
    }
}
