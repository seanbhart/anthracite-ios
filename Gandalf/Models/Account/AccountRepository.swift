//
//  AccountRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/5/21.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol AccountRepositoryDelegate {
    func accountDataUpdate()
    func requestError(title: String, message: String)
    func showLogin()
}

class AccountRepository {
    var className = "AccountRepository"
    
    var delegate: AccountRepositoryDelegate?
    var accounts = [Account]()
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    init() {
        query = Settings.Firebase.db().collection("accounts")
    }
    
    func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        listener = query
            .whereField("status", isEqualTo: 1)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error { print("\(className) - LISTENER ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                
                accounts.removeAll()
                accounts = snapshot.documents.compactMap { queryDocumentSnapshot -> Account? in
//                    print("\(className) - account: \(queryDocumentSnapshot.data())")
                    getImage(accountId: queryDocumentSnapshot.documentID)
                    return try? queryDocumentSnapshot.data(as: Account.self)
                }
//                print("\(className) - accounts count: \(accounts.count)")
                if let parent = self.delegate {
                    parent.accountDataUpdate()
                }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
    
    func getImage(accountId: String) {
        let imageRef = Storage.storage().reference().child(accountId + ".png")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if error != nil { return }
            guard let imgData = data else { return }
            
            for (i, a) in self.accounts.enumerated() {
                if a.id == accountId {
                    self.accounts[i].image = UIImage(data: imgData)
                }
            }
            
            if let parent = self.delegate {
                parent.accountDataUpdate()
            }
        }
    }
}
