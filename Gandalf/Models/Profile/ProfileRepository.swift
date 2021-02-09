//
//  ProfileRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/5/21.
//

import FirebaseAuth
import FirebaseFirestore

protocol ProfileRepositoryDelegate {
    func profileDataUpdate()
    func requestError(message: String)
}

class ProfileRepository {
    var className = "ProfileRepository"
    
    var delegate: ProfileRepositoryDelegate?
    var accountId: String!
    var profile: Profile?
    
    init(id: String) {
        accountId = id
    }
    
    func getAccount() {
        print("\(self.className) - getAccount: \(accountId)")
        Settings.Firebase.db().collection("accounts").document(accountId)
            .getDocument(completion: { (snapshot, error) in
                if let err = error {
                    print("\(self.className) - GET ACCOUNT ERROR: \(err)")
                }
                guard let snapshot = snapshot else { print("\(self.className) snapshot error: \(error!)"); return }
                print("\(self.className) - snapshot data: \(snapshot.data())")
                if let profile = try? snapshot.data(as: Profile.self) {
                    self.profile = profile
                    
                    if let parent = self.delegate {
                        parent.profileDataUpdate()
                    }
                }
            })
        
//        Settings.Firebase.db().collection("accounts").document(accountId).collection("private")
//            .getDocuments(completion: { (snapshot, error) in
//                if let err = error {
//                    print("\(self.className) - GET ACCOUNT PRIVATE ERROR: \(err)")
//                }
//                guard let snapshot = snapshot else { print("\(self.className) private snapshot error: \(error!)"); return }
//                for d in snapshot.documents {
//                    print("\(self.className) - private account document: \(d.documentID): \(d.data())")
//                }
//            })
    }
    
    func setUserName(username: String) {
        guard let firUser = Auth.auth().currentUser else { return }
        
        Settings.Firebase.db().collection("accounts").document(firUser.uid).setData([
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
        guard let firUser = Auth.auth().currentUser else { return }
        Settings.Firebase.db().collection("group")
            .whereField("status", isEqualTo: 1)
            .whereField("members", arrayContains: firUser.uid)
            .getDocuments(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - FIRESTORE GET ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) snapshot error: \(error!)"); return }
                
                self.profile?.groupCount = snapshot.documents.count
                
                if let parent = self.delegate {
                    parent.profileDataUpdate()
                }
            })
    }
}
