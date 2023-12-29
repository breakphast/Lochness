//
//  Bet.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import Foundation

class Bet: Identifiable, Codable {
    var id = UUID()
    let type: String
    var result: String
    let line: Double?
    let odds: Int
    var points: Double
    var stake = 100.0
    let team: String
    let userID: String
    let leagueCode: String
    let timestamp: Date
    let gameID: String
    
    var isDeleted: Bool? = nil
    var deletedAt: Date? = nil
    
    init(id: UUID = UUID(), type: String, result: String, line: Double?, odds: Int, points: Double, stake: Double = 100.0, team: String, userID: String, leagueCode: String, timestamp: Date, gameID: String, isDeleted: Bool?, deletedAt: Date?) {
        self.id = id
        self.type = type
        self.result = result
        self.line = line
        self.odds = odds
        self.points = points
        self.stake = stake
        self.team = team
        self.userID = userID
        self.leagueCode = leagueCode
        self.timestamp = timestamp
        self.gameID = gameID
        self.isDeleted = isDeleted
        self.deletedAt = deletedAt
    }
}

enum BetResult: String {
    case win = "Win"
    case loss = "Loss"
    case push = "Push"
    case pending = "Pending"
}

enum BetType: String, CaseIterable {
    case spread = "Spread"
    case moneyline = "Moneyline"
    case over = "Over"
    case under = "Under"
}
