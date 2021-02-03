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
}

class GroupRepository {
    var className = "GroupRepository"
    
    var delegate: GroupRepositoryDelegate?
    var groups = [Group]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init() {
        query = Settings.Firebase.db().collection("group")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        guard let firUser = Auth.auth().currentUser else { return }
        stopObserving()
        
        // Listen for NotionAction for the signed in account in the same time period
        // as the listener for Notions
        listener = query
            .whereField("status", isEqualTo: 1)
            .whereField("members", arrayContains: firUser.uid)
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error { print("\(className) - LISTENER ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                
                self.groups.removeAll()
                self.groups = snapshot.documents.compactMap { queryDocumentSnapshot -> Group? in
                    return try? queryDocumentSnapshot.data(as: Group.self)
                }
                
                if let parent = self.delegate {
                    parent.groupDataUpdate()
                }
            }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
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
            } else {
                print("\(self.className) - FIREBASE: group successfully created")
            }
        }
    }
    
    func editGroupTitle(group: String, title: String) {
        Settings.Firebase.db().collection("group").document(group).setData([
            "title": title
        ], merge: true) { err in
            if let err = err {
                print("\(self.className) - FIREBASE: ERROR editing group title: \(err)")
            } else {
                print("\(self.className) - FIREBASE: group successfully edited group title")
            }
        }
    }
}
