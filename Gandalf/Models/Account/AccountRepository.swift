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
    func requestError(message: String)
}

class AccountRepository {
    var className = "AccountRepository"
    let currentTutorial = "v1.0.0"
    
    var delegate: AccountRepositoryDelegate?
    var accountId: String!
    var account: Account?
    
    init?() {
        guard let firUser = Auth.auth().currentUser else { return nil }
        accountId = firUser.uid
    }
    
    func getAccount() {
        print("\(self.className) - getAccount: \(accountId)")
        Settings.Firebase.db().collection("accounts").document(accountId)
            .getDocument(completion: { (snapshot, error) in
                if let err = error {
                    print("\(self.className) - GET ACCOUNT ERROR: \(err)")
                }
                guard let snapshot = snapshot else { print("\(self.className) snapshot error: \(error!)"); return }
//                print("\(self.className) - snapshot data: \(snapshot.data())")
                if let account = try? snapshot.data(as: Account.self) {
                    self.account = account
                    
                    // Now get the private subcollections for this account
                    Settings.Firebase.db().collection("accounts").document(self.accountId).collection("private")
                        .getDocuments(completion: { (pSnapshot, error) in
                            if let err = error {
                                print("\(self.className) - GET ACCOUNT PRIVATE ERROR: \(err)")
                                if let parent = self.delegate {
                                    parent.accountDataUpdate()
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
                                    case "pii":
                                        if let pii = try? p.data(as: AccountPii.self) {
                                            self.account?.pii = pii
                                        }
                                    case "settings":
                                        if let settings = try? p.data(as: AccountSettings.self) {
                                            self.account?.settings = settings
                                        }
                                    default:
                                        print("\(self.className) - ERROR unknown private account document: \(p.documentID)")
                                    }
                                }
                                
                                if let parent = self.delegate {
                                    parent.accountDataUpdate()
                                }
                            }
                        })
                }
            })
    }
    
    func setUserName(username: String) {
        Settings.Firebase.db().collection("accounts").document(accountId!).setData([
            "username": username,
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR updating display name: \(err)")
                if let parent = self.delegate {
                    parent.requestError(message: "We're sorry, there was a problem updating your name. Please try again.")
                }
            } else {
                print("\(self.className) - FIREBASE: display name successfully updated")
            }
        }
    }
    
    func getGroupCount() {
        Settings.Firebase.db().collection("group")
            .whereField("status", isEqualTo: 1)
            .whereField("members", arrayContains: accountId!)
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
        Settings.Firebase.db().collection("accounts").document(accountId!).collection("private").document("metadata").setData([
            "tutorials": FieldValue.arrayUnion([currentTutorial + "-" + view]),
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
