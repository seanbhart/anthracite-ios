//
//  ShadowPositionRepository.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import FirebaseFirestore

protocol ShadowPositionRepositoryDelegate {
    func shadowPositionsDataUpdate()
    func showLogin()
}

class ShadowPositionRepository {
    var className = "ShadowPositionRepository"
    
    var delegate: ShadowPositionRepositoryDelegate?
    var shadowPositions = [ShadowPosition]()
    
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
        query = Settings.Firebase.db().collection("accounts").document(firUser.uid).collection("shadow_positions")
    }

    private var listener: ListenerRegistration?

    func observeQuery() {
        guard let query = query else { return }
        stopObserving()

        listener = query
            .addSnapshotListener { [unowned self] (snapshot, error) in
                if let err = error {
                    if let parent = self.delegate {
                        print("\(className) - LISTENER ERROR: \(err)")
                        parent.showLogin()
                    }
                }
                guard let snapshot = snapshot else { print("\(className) snapshot error: \(error!)"); return }
                
                self.shadowPositions.removeAll()
                self.shadowPositions = snapshot.documents.compactMap { doc -> ShadowPosition? in
                    return try? doc.data(as: ShadowPosition.self)
                }
                
                if let parent = self.delegate {
                    parent.shadowPositionsDataUpdate()
                }
        }
    }

    func stopObserving() {
        print("\(className): stopObserving")
        listener?.remove()
    }
}
