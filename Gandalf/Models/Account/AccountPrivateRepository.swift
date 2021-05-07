//
//  AccountPrivateRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 5/7/21.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol AccountPrivateRepositoryDelegate {
    func accountPrivateDataUpdate()
    func requestError(title: String, message: String)
    func showLogin()
}

class AccountPrivateRepository {
    var className = "AccountPrivateRepository"
    
    var delegate: AccountPrivateRepositoryDelegate?
    var account: Account?
    
    fileprivate var docRef: DocumentReference? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeDoc()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    init() {
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        docRef = Settings.Firebase.db().collection("accounts").document(firUser.uid)
    }
    
    func observeDoc() {
        guard let docRef = docRef else { return }
        stopObserving()

        listener = docRef.addSnapshotListener { [unowned self] (snapshot, error) in
            if let err = error {
                print("\(self.className) - GET ACCOUNT ERROR: \(err)")
                if let parent = self.delegate { parent.showLogin() }
                return
            }
            
            guard let snapshot = snapshot else {
                print("\(self.className) snapshot error: \(error!)")
                if let parent = self.delegate { parent.showLogin() }
                return
            }
//                print("\(self.className) - snapshot data: \(snapshot.data())")
            if let account = try? snapshot.data(as: Account.self) {
                self.account = account
                getImage()
                
                // Now get the private subcollections for this account
                Settings.Firebase.db().collection("accounts").document(account.id!).collection("private")
                    .getDocuments(completion: { (pSnapshot, error) in
                        if let err = error {
                            print("\(self.className) - GET ACCOUNT PRIVATE ERROR: \(err)")
                            if let parent = self.delegate {
                                parent.accountPrivateDataUpdate()
                            }
                        } else {
                            guard let pSnapshot = pSnapshot else { print("\(self.className) private snapshot error: \(error!)"); return }
                            for p in pSnapshot.documents {
//                                    print("\(self.className) - private account document: \(p.documentID): \(p.data())")
                                switch p.documentID {
                                case "metadata":
                                    if let metadata = try? p.data(as: AccountMetadata.self) {
                                        self.account?.metadata = metadata
                                    }
//                                    case "pii":
//                                        if let pii = try? p.data(as: AccountPii.self) {
//                                            self.account?.pii = pii
//                                        }
//                                    case "settings":
//                                        if let settings = try? p.data(as: AccountSettings.self) {
//                                            self.account?.settings = settings
//                                        }
                                default:
                                    print("\(self.className) - ERROR unknown private account document: \(p.documentID)")
                                }
                            }
                            
                            if let parent = self.delegate {
                                parent.accountPrivateDataUpdate()
                            }
                        }
                    })
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
    
//    func getAccount(accountId: String) {
//        print("\(self.className) - getAccount: \(accountId)")
//        Settings.Firebase.db().collection("accounts").document(accountId)
//            .getDocument(completion: { (snapshot, error) in
//
//            })
//    }
    
    // All necessary auth steps when signing out
    func signOut() {
        // Obviously can only be used on the current user
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        // Remove the messaging cert to prevent messages being sent to this device
        Settings.Firebase.db().collection("accounts").document(firUser.uid).collection("private").document("metadata").setData([
            "messaging_token": "",
            "messaging_token_updated": Date().timeIntervalSince1970,
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR updating token: \(err)")
            } else {
                print("\(self.className) - FIREBASE: updated token")
            }
        }
        
        // Clear local data
        account = nil
    }
    
    func setUserName(username: String) {
        // Can only be used on the current user
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        // Check whether the username is already in use
        Settings.Firebase.db().collection("accounts")
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
                    Settings.Firebase.db().collection("accounts").document(firUser.uid).setData([
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
    
    func addTutorialViewFor(view: String) {
        // Can only be used on the current user
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        Settings.Firebase.db().collection("accounts").document(firUser.uid).collection("private").document("metadata").setData([
            "tutorials": FieldValue.arrayUnion([Settings.currentTutorial + "-" + view]),
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR adding tutorial view: \(err)")
            } else {
                print("\(self.className) - FIREBASE: added tutorial view")
            }
        }
    }
    
    func getImage() {
        guard let account = account else { return }
        guard let id = account.id else { return }
        let imageRef = Storage.storage().reference().child(id + ".png")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if error != nil { return }
            guard let imgData = data else { return }
            self.account!.image = UIImage(data: imgData)
            
            if let parent = self.delegate {
                parent.accountPrivateDataUpdate()
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
