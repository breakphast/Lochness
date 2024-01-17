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
    
    func makeLeague(name: String, userID: String, size: Int, sport: String, leagueMode: String, wagerMode: String, playoffMode: String?, playoffSize: Int?, payoutStructure: String?, entryFee: Double?) -> League {
        return League(
            name: name,
            users: [userID],
            size: size,
            sport: sport,
            leagueMode: leagueMode,
            wagerMode: wagerMode,
            playoffMode: playoffMode,
            playoffSize: playoffSize,
            payoutStructure: payoutStructure,
            entryFee: entryFee
        )
    }
    
    func addUserToLeague(user: User, league: League) async throws {
        if let leagueReference {
            let documentRef = leagueReference.document(league.id.uuidString)
            try await documentRef.updateData(["users": FieldValue.arrayUnion(["EKWIEIWKIWKEJI"])])
        }
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
        
        let size = data["size"] as? Int ?? 0
        let sport = data["sport"] as? String ?? ""
        
        let wagerMode = data["wagerMode"] as? String ?? ""
        let leagueMode = data["leagueMode"] as? String ?? ""
        
        let playoffMode = data["playoffMode"] as? String ?? nil
        let playoffSize = data["playoffSize"] as? Int ?? nil
        
        let payoutStructure = data["payoutStructure"] as? String ?? nil
        let entryFee = data["entryFee"] as? Double ?? nil
        
        return League(
            id: UUID(uuidString: id) ?? UUID(),
            name: name,
            users: usersArray,
            size: size,
            sport: sport, 
            leagueMode: leagueMode,
            wagerMode: wagerMode,
            playoffMode: playoffMode,
            playoffSize: playoffSize,
            payoutStructure: payoutStructure,
            entryFee: entryFee
        )
    }
}
