//
//  ShadowRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import FirebaseFirestore

protocol ShadowRepositoryDelegate {
    func shadowsDataUpdate()
    func showLogin()
}

class ShadowRepository {
    var className = "ShadowRepository"
    
    var delegate: ShadowRepositoryDelegate?
    var shadows = [Shadow]()
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    init?() {
        guard let firUser = Settings.Firebase.auth().currentUser else { return nil }
        query = Settings.Firebase.db().collection("accounts").document(firUser.uid).collection("shadows")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()

        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            if let err = error { print("\(self.className) - LISTENER ERROR: \(err)"); return }
            guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
            
            let shadows = snapshot.documents.compactMap { doc -> Shadow? in
                return try? doc.data(as: Shadow.self)
            }
            self.shadows.removeAll()
            self.shadows = shadows
            
            if let parent = self.delegate {
                parent.shadowsDataUpdate()
            }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
}
