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
    
    func makeLeague(name: String, userID: String, size: Int, sport: String, wagerMode: String, playoffMode: String, playoffSize: Int) -> League {
        return League(
            name: name,
            users: [userID],
            size: size,
            sport: sport,
            wagerMode: wagerMode,
            playoffMode: playoffMode,
            playoffSize: playoffSize
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
        let usersArray = data["users"] as? [String] ?? []
        let size = data["size"] as? Int ?? LeagueSize.four.rawValue
        let sport = data["sport"] as? String ?? Sport.nfl.rawValue
        let wagerMode = data["wagerMode"] as? String ?? WagerMode.fixed.rawValue
        let playoffMode = data["playoffMode"] as? String ?? PlayoffMode.elimination.rawValue
        let playoffSize = data["playoffSize"] as? Int ?? PlayoffSize.six.rawValue
        
        return League(
            id: UUID(uuidString: id) ?? UUID(),
            name: name,
            users: usersArray,
            size: size,
            sport: sport,
            wagerMode: wagerMode,
            playoffMode: playoffMode,
            playoffSize: playoffSize
        )
    }
}
