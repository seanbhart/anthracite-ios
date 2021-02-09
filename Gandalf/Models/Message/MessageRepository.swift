//
//  MessageRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions

protocol MessageRepositoryDelegate {
    func messageDataUpdate()
    func messageCreateError(text: String)
    func getLocalTickers() -> [Ticker]
}

class MessageRepository {
    var className = "MessageRepository"
    
    var delegate: MessageRepositoryDelegate?
    var groupId: String!
    var messages = [MessageGandalf]()
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
    
    init(groupId: String) {
        self.groupId = groupId
        query = Settings.Firebase.db().collection("group").document(groupId).collection("messages")
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
                
                messages.removeAll()
                messages = snapshot.documents.compactMap { queryDocumentSnapshot -> MessageGandalf? in
                    return try? queryDocumentSnapshot.data(as: MessageGandalf.self)
                }
                
                // Query for the display names of all message senders
                // and convert any embedded Tickers from dict to objects
                for (i, m) in messages.enumerated() {
                    getAccountDisplayName(account: m.account)
                    messages[i].fillTickers()
                }
                
                // Clear the ticker list and add new ticker summary data
                tickers.removeAll()
                // Get a list of all tickers with no duplicates
                let tickerStringsAll = messages.compactMap({ $0.tickers?.map({ $0.ticker }) }).reduce([], +)
                // Count how many of each ticker exist
                let tickerOccurrences = tickerStringsAll.reduce(into: [:]) { $0[$1, default: 0] += 1 }
                // Create the Ticker object and add the weighted average sentiment
                for ticker in tickerOccurrences {
                    guard let key = ticker.key else { return }
                    var tObj = Ticker(ticker: key, responseCount: ticker.value)
                    
                    // TODO: simplify with closure method
                    var sentimentSum = 0
                    for m in messages {
                        guard let mTickers = m.tickers else { continue }
                        for t in mTickers {
                            if t.ticker == tObj.ticker {
                                sentimentSum += t.getSentimentMathValue()
                            }
                        }
                    }
                    tObj.wAvgSentiment = Float(sentimentSum)
                    tickers.append(tObj)
                }
                
                var selectedTickers = [Ticker]()
                // but save the currently selected Tickers to update the new list
                if let parent = delegate {
                    selectedTickers = parent.getLocalTickers().filter({ $0.selected })
                }
                // Set tickers in the new list to selected if they were previously
                // selected (if they exist in the new list). However, don't replace
                // the new Ticker with the old one - the response count will not update.
                tickers = tickers.map({
                    var t = $0
                    if selectedTickers.filter({ $0.ticker == t.ticker }).count > 0 {
                        t.selected = true
                        return t
                    } else {
                        return $0
                    }
                })
                
                if let parent = delegate {
                    parent.messageDataUpdate()
                }
            }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
    
    func createMessage(text: String, tickers: [MessageTicker]) {
        if text == "" { return }
        
        // Convert TickerInputs to an array of dictionaries
//        var tickerDicts = [[String:String]]()
//        for ticker in tickers {
//            var tickerDict = [String:String]()
//            tickerDict["ticker"] = ticker.ticker
//            tickerDict["sentiment_indicator"] = String(ticker.sentiment.rawValue)
//            tickerDicts.append(tickerDict)
//        }
        var tickerSentiment = [String:Double]()
        for ticker in tickers {
            tickerSentiment[ticker.ticker] = Double(ticker.sentiment.rawValue)
        }
        
        Functions.functions().httpsCallable("createMessage").call([
            "group_id": groupId!,
            "text": text,
            "ticker_sentiment": tickerSentiment,
            "timestamp": Date().timeIntervalSince1970,
        ]) { (result, error) in
            if let error = error as NSError? {
                // If the message was not created, pass the message text
                // back to the input to save it for another attempt.
                if let parent = self.delegate {
                    parent.messageCreateError(text: text)
                }
                
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("\(self.className) - FIREBASE FUNCTION createMessage ERROR: code: \(code), message: \(message), details: \(details)")
                }
            }
            print("createMessage RESULT: \(result.debugDescription)")
            if let data = (result?.data as? [String: Any]) {
                print("createMessage RESULT data: \(data)")
            }
        }
    }
    
    func deleteMessage(id: String?) {
        guard let id = id else { return }
        Settings.Firebase.db().collection("group").document(groupId).collection("messages").document(id).setData([
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
                if let username = data["username"] as? String {
                    self.accountNames[account] = username
                } else if let name = data["name"] as? [String:String] {
                    let given = name["given"] ?? ""
                    let family = name["family"] ?? ""
                    self.accountNames[account] = given + " " + family
                }
                
                if let parent = self.delegate {
                    parent.messageDataUpdate()
                }
            })
    }
    
    func addView() {
        Functions.functions().httpsCallable("addView").call([
            "group_id": groupId!,
            "timestamp": Date().timeIntervalSince1970,
        ]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print("\(self.className) - FIREBASE FUNCTION addView ERROR: code: \(code), message: \(message), details: \(details)")
                }
            }
            print("addView RESULT: \(result.debugDescription)")
            if let data = (result?.data as? [String: Any]) {
                print("addView RESULT data: \(data)")
            }
        }
    }
}
