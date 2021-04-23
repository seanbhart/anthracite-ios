//
//  AccountRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/5/21.
//

import FirebaseAuth
import FirebaseFirestore

protocol AccountRepositoryDelegate {
    func accountDataUpdate()
    func requestError(title: String, message: String)
    func showLogin()
}

class AccountRepository {
    var className = "AccountRepository"
    
    var delegate: AccountRepositoryDelegate?
    var account: Account?
    
    fileprivate var docRef: DocumentReference? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeDoc()
            }
        }
    }
    
    init?() {
        guard let firUser = Settings.Firebase.auth().currentUser else { return nil }
        docRef = Settings.Firebase.db()
            .collection("accounts")
            .document(firUser.uid)
    }
    
    private var listener: ListenerRegistration?
    
    func observeDoc() {
        guard let docRef = docRef else { return }
        stopObserving()
        
        listener = docRef.addSnapshotListener { [unowned self] (snapshot, error) in
            if let err = error {
                print("\(self.className) - LISTENER ERROR: \(err)")
                if let parent = self.delegate { parent.showLogin() }
                return
            }
            
            guard let snapshot = snapshot else {
                print("\(self.className) snapshot error: \(error!)")
                if let parent = self.delegate { parent.showLogin() }
                return
            }
            
            print("\(self.className) - snapshot data: \(snapshot.data())")
            if let account = try? snapshot.data(as: Account.self) {
                self.account = account
            } else {
                print("\(self.className) create Account object error")
                if let parent = self.delegate { parent.showLogin() }
            }
        }
    }
    
    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
    
    // All necessary auth steps when signing out
    func signOut() {
//        guard let acct = account else { return }
//        guard let accountId = acct.id else { return }
        
//        // Remove the messaging cert to prevent messages being sent to this device
//        Settings.Firebase.db()
//            .collection("tokens")
//            .document()
//            .setData([
//                "account": accountId,
//                "type": "messaging",
//                "token": "",
//                "updated": Date().timeIntervalSince1970,
//            ]) { err in
//                if let err = err {
//                    print("\(self.className) - FIREBASE: ERROR updating token: \(err)")
//                } else {
//                    print("\(self.className) - FIREBASE: updated token")
//                }
//            }
        
        // Clear local data
        account = nil
    }
    
    func setUserName(username: String) {
        guard let acct = account else { return }
        guard let accountId = acct.id else { return }
        
        // Check whether the username is already in use
        Settings.Firebase.db()
            .collection("usernames")
            .whereField("username", in: [username])
            .getDocuments(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - FIRESTORE GET ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) snapshot error: \(error!)"); return }
                
                if snapshot.documents.count > 0 {
                    // Username already used, send error
                    if let parent = self.delegate {
                        parent.requestError(title: "Username Taken", message: "We're sorry, that username already exists. Please try a different username.")
                    }
                } else {
                    
                    // The username does not exist, change the username
                    Settings.Firebase.db()
                        .collection("usernames")
                        .document(accountId).setData([
                            "username": username,
                        ], merge: true) { err in
                            if let err = err {
                                print("\(self.className) - FIREBASE: ERROR updating display name: \(err)")
                                if let parent = self.delegate {
                                    parent.requestError(title: "We messed up!", message: "We're sorry, there was a problem updating your name. Please try again.")
                                }
                            } else {
                                print("\(self.className) - FIREBASE: display name successfully updated")
                            }
                        }
                    
                }
            })
    }
    
    func getGroupCount() {
        guard let acct = account else { return }
        guard let accountId = acct.id else { return }
        
        Settings.Firebase.db().collection("group")
            .whereField("status", isEqualTo: 1)
            .whereField("members", arrayContains: accountId)
            .getDocuments(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - FIRESTORE GET ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) snapshot error: \(error!)"); return }
                
                self.account?.groupCount = snapshot.documents.count
                
                if let parent = self.delegate {
                    parent.accountDataUpdate()
                }
            })
    }
    
    func addTutorialViewFor(view: String) {
        guard let acct = account else { return }
        guard let accountId = acct.id else { return }
        
        Settings.Firebase.db()
            .collection("accounts")
            .document(accountId)
            .setData([
                "tutorials": FieldValue.arrayUnion([Settings.currentTutorial + "-" + view]),
            ], merge: true) { err in
                if let err = err {
                    print("\(self.className) - FIREBASE: ERROR adding tutorial view: \(err)")
                } else {
                    print("\(self.className) - FIREBASE: added tutorial view")
                }
            }
    }
    
//    func updateImageUrl(url: String) {
//        Settings.Firebase.db().collection("accounts").document(accountId!).setData([
//            "image_url": url,
//        ], merge: true) { err in
//            if let err = err {
//                print("\(self.className) - FIREBASE: ERROR updating image url: \(err)")
//                if let parent = self.delegate {
//                    parent.requestError(message: "We're sorry, there was a problem updating your image. Please try again.")
//                }
//            } else {
//                print("\(self.className) - FIREBASE: image url successfully updated")
//            }
//        }
//    }
}
