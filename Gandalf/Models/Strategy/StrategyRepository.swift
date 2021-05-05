//
//  StrategyRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import FirebaseFirestore

protocol StrategyRepositoryDelegate {
    func strategyDataUpdate()
    func showLogin()
}

class StrategyRepository {
    var className = "StrategyRepository"
    
    var delegate: StrategyRepositoryDelegate?
    var strategies = [Strategy]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init() {
        query = Settings.Firebase.db().collection("strategies").order(by: "created", descending: true)
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
    
    func createStrategy(strategy: Strategy) {
        print("\(className): createStrategy")
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        
        // Convert the nested Orders to dict to upload
        let orders = strategy.orders.map { order -> [String:Any] in
            print("\(className): order: \(order)")
            guard let symbol = order.symbol else { return [:] }
            print("\(className): symbol: \(symbol)")
            var orderDict = [
                "direction": NSNumber(value: order.direction),
                "predict_price_direction": NSNumber(value: order.predictPriceDirection),
                "symbol": symbol,
                "type": NSNumber(value: order.type),
            ] as [String : Any]
            print("\(className): orderDict: \(orderDict)")
            if let price = order.price {
                orderDict["price"] = NSNumber(value: price)
            }
            print("\(className): orderDict 2: \(orderDict)")
            if let expiration = order.expiration {
                orderDict["expiration"] = NSNumber(value: expiration)
            }
            print("\(className): orderDict 3: \(orderDict)")
            return orderDict
        }
        
        Settings.Firebase.db().collection("strategies").document().setData([
            "status": NSNumber(value: 1),
            "caption": strategy.caption ?? "",
            "created": Date().timeIntervalSince1970 * 1000,
            "creator": firUser.uid,
            "orders": orders,
            "reactions": [
                "dislike": NSNumber(value: 0),
                "like": NSNumber(value: 0),
                "ordering": NSNumber(value: 0),
            ],
            "window_expiration": strategy.windowExpiration,
            "version": "v3.0.0",
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR creating Strategy: \(err)")
//                if let parent = self.delegate {
//                    parent.requestError(message: "We're sorry, there was a problem creating the Strategy. Please try again.")
//                }
            } else {
                print("\(self.className) - FIREBASE: Strategy successfully created")
            }
        }
    }
}
