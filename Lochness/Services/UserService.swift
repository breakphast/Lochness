//
//  UserService.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/29/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class UserService {
    @Published var allUsers = [User]()
    @Published var currentUser: User?
    
    private var userSubscription: AnyCancellable?
    private var userListener: ListenerRegistration?
    private var userReference: CollectionReference?
    
    private var db = Firestore.firestore()
    
    init() {
        self.userReference = db.collection("users")
        getUsersFromFirestore()
//        Task {
//            try await self.add(user: user)
//        }
    }
    
    // MARK: Firebase Functions
    func add(user: User) async throws {
        if let userReference {
            try await FirebaseManager.add(item: user, id: user.id.uuidString, to: userReference)
        }
    }
    
    private func getUsersFromFirestore() {
        if let userReference {
            self.userListener = FirebaseManager.fetch(query: userReference, convert: parseUserFromDocument(_:)) { [weak self] users in
                self?.allUsers = users
            }
        }
    }
    
    private func parseUserFromDocument(_ document: QueryDocumentSnapshot) -> User {
        let data = document.data()

        let id = data["id"] as? String ?? ""
        let username = data["username"] as? String ?? ""
        
        return User(
            id: UUID(uuidString: id) ?? UUID(),
            username: username
        )
    }
}
