//
//  LeagueService.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/2/24.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class LeagueService {
    @Published var allLeagues = [League]()
    
    private var leagueSubscription: AnyCancellable?
    private var leagueListener: ListenerRegistration?
    private var leagueReference: CollectionReference?
    
    private var db = Firestore.firestore()

    init() {
        self.leagueReference = db.collection("leagues")
        getLeaguesFromFirestore()
    }
    
    func makeLeague(name: String, isPrivate: Bool, userID: String) -> League {
        return League(
            name: name,
            isPrivate: isPrivate,
            users: [userID]
        )
    }
    
    func add(league: League) async throws {
        if let leagueReference {
            try await FirebaseManager.add(item: league, id: league.id.uuidString, to: leagueReference)
        }
    }
    
    private func getLeaguesFromFirestore() {
        if let leagueReference {
            self.leagueListener = FirebaseManager.fetch(query: leagueReference, convert: parseLeagueFromDocument(_:)) { [weak self] leagues in
                self?.allLeagues = leagues
            }
        }
    }
    
    private func parseLeagueFromDocument(_ document: QueryDocumentSnapshot) -> League {
        let data = document.data()
        
        let id = data["id"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let isPrivate = data["isPrivate"] as? Bool ?? false
        let usersArray = data["users"] as? [String] ?? []
        
        return League(
            id: UUID(uuidString: id) ?? UUID(),
            name: name,
            isPrivate: isPrivate,
            users: usersArray
        )
    }
}
