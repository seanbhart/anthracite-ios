//
//  GroupRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import FirebaseAuth
import FirebaseFirestore

protocol GroupRepositoryDelegate {
    func groupDataUpdate()
    func requestError(message: String)
}

class GroupRepository {
    var className = "GroupRepository"
    
    var delegate: GroupRepositoryDelegate?
    var groups = [Group]()

    func getGroups() {
        guard let firUser = Auth.auth().currentUser else { return }
        Settings.Firebase.db().collection("group")
            .whereField("status", isEqualTo: 1)
            .whereField("members", arrayContains: firUser.uid)
            .getDocuments(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - FIRESTORE GET ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) snapshot error: \(error!)"); return }
                
                self.groups.removeAll()
                self.groups = snapshot.documents.compactMap { queryDocumentSnapshot -> Group? in
                    return try? queryDocumentSnapshot.data(as: Group.self)
                }
                
                if let parent = self.delegate {
                    parent.groupDataUpdate()
                }
            })
    }
    
    func createGroup(title: String) {
        guard let firUser = Auth.auth().currentUser else { return }
        
        Settings.Firebase.db().collection("group").document().setData([
            "created": Date().timeIntervalSince1970,
            "creator": firUser.uid,
            "members": [firUser.uid],
            "status": NSNumber(value: 1),
            "title": title
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR creating group: \(err)")
                if let parent = self.delegate {
                    parent.requestError(message: "We're sorry, there was a problem creating the group. Please try again.")
                }
            } else {
                print("\(self.className) - FIREBASE: group successfully created")
                self.getGroups()
            }
        }
    }
    
    func joinGroup(code: String) {
        guard let firUser = Auth.auth().currentUser else { return }
        
        // Ensure the group already exists first
        Settings.Firebase.db().collection("group").document(code)
            .getDocument(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - FIRESTORE GET ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) snapshot error: \(error!)"); return }
                
                if snapshot.exists {
                    Settings.Firebase.db().collection("group").document(code).setData([
                        "members": FieldValue.arrayUnion([firUser.uid])
                    ], merge: true) { err in
                        if let err = err {
                            print("\(self.className) - FIREBASE: ERROR joining group: \(err)")
                            if let parent = self.delegate {
                                parent.requestError(message: "We're sorry, there was a problem joining the group. Please try again.")
                            }
                        } else {
                            print("\(self.className) - FIREBASE: group successfully joined")
                            self.getGroups()
                        }
                    }
                } else {
                    if let parent = self.delegate {
                        parent.requestError(message: "We're sorry, that group code does not appear valid. Please check the code and try again.")
                    }
                }
            })
    }
    
    func editGroupTitle(groupId: String, title: String) {
        Settings.Firebase.db().collection("group").document(groupId).setData([
            "title": title
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR editing group title: \(err)")
                if let parent = self.delegate {
                    parent.requestError(message: "We're sorry, there was a problem editing the name. Please try again.")
                }
            } else {
                print("\(self.className) - FIREBASE: group successfully edited group title")
                self.getGroups()
            }
        }
    }
    
    func removeCurrentAccount(groupId: String) {
        guard let firUser = Auth.auth().currentUser else { return }
        
        Settings.Firebase.db().collection("group").document(groupId).setData([
            "members": FieldValue.arrayRemove([firUser.uid])
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR editing group title: \(err)")
                if let parent = self.delegate {
                    parent.requestError(message: "We're sorry, there was a problem removing you from the group. Please try again.")
                }
            } else {
                print("\(self.className) - FIREBASE: group successfully edited group title")
                self.getGroups()
            }
        }
    }
}
