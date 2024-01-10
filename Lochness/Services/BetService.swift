//
//  BetService.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class BetService {
    @Published var allBets = [Bet]()
    
    private var betSubscription: AnyCancellable?
    private var betsListener: ListenerRegistration?
    private var betReference: CollectionReference?
    
    private var db = Firestore.firestore()
    
    init() {
        self.betReference = db.collection("bets")
        getBetsFromFirestore()
    }
        
    func makeBet(from betOption: BetOption, user: User, league: String?, contest: String?) -> Bet {
        return Bet(
            type: betOption.betType.rawValue,
            result: BetResult.pending.rawValue,
            line: betOption.line ?? nil,
            odds: betOption.odds,
            points: 10, 
            team: betOption.team,
            matchupTeamsDescription: betOption.matchupTeamsDescription, 
            userID: user.id.uuidString,
            leagueID: league ?? nil,
            timestamp: Date(),
            gameID: betOption.game.id,
            isDeleted: nil,
            deletedAt: nil
        )
    }
    
    // MARK: Firebase Functions
    func add(bet: Bet) async throws {
        if let betReference {
            try await FirebaseManager.add(item: bet, id: bet.id.uuidString, to: betReference)
        }
    }
    
    func delete(bet: Bet) async throws {
        guard let betReference else { return }

        let documentRef = betReference.document(bet.id.uuidString)

        do {
            let updateData: [String: Any] = [
                "isDeleted": true,
                "deletedAt": Date()
            ]

            try await documentRef.updateData(updateData)
            print("Bet marked as deleted successfully")
        } catch {
            print("Error marking bet as deleted: \(error.localizedDescription)")
        }
    }
    
    private func getBetsFromFirestore() {
        if let betReference {
            self.betsListener = FirebaseManager.fetch(query: betReference, convert: parseBetFromDocument(_:)) { [weak self] bets in
                self?.allBets = bets.filter({$0.isDeleted == nil})
            }
        }
    }
    
    private func parseBetFromDocument(_ document: QueryDocumentSnapshot) -> Bet {
        let data = document.data()

        let id = data["id"] as? String ?? ""
        let type = data["type"] as? String ?? ""
        let result = data["result"] as? String ?? "Pending"
        let line = data["line"] as? Double
        let odds = data["odds"] as? Int ?? 0
        let points = data["points"] as? Double ?? 0.0
        let stake = data["stake"] as? Double ?? 100.0
        let team = data["team"] as? String ?? ""
        let userID = data["userID"] as? String ?? ""
        let leagueID = data["leagueID"] as? String ?? nil
        let timestamp = data["timestamp"] as? Date ?? Date()
        let gameID = data["gameID"] as? String ?? ""
        let matchupTeamsDescription = data["matchupTeamsDescription"] as? String ?? ""
        
        let isDeleted = data["isDeleted"] as? Bool ?? nil
        let deletedAt = data["deletedAt"] as? Date ?? nil

        return Bet(
            id: UUID(uuidString: id) ?? UUID(),
            type: type,
            result: result,
            line: line,
            odds: odds,
            points: points,
            stake: stake,
            team: team,
            matchupTeamsDescription: matchupTeamsDescription,
            userID: userID,
            leagueID: leagueID, 
            timestamp: timestamp,
            gameID: gameID, 
            isDeleted: isDeleted ?? nil,
            deletedAt: deletedAt ?? nil
        )
    }
    
    static func calculatePayout(odds: Int, wager: Double) -> (payout: Double, profit: Double) {
        var profit: Double = 0.0
        var payout: Double = 0.0

        if odds > 0 {
            profit = (Double(odds) / 100.0) * wager
        } else {
            profit = wager / (Double(abs(odds)) / 100.0)
        }

        payout = wager + profit

        return (payout, profit)
    }
}
