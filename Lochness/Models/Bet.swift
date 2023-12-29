//
//  Bet.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import Foundation

struct Bet: Identifiable, Codable {
    var id = UUID()
    let type: String
    var result: String
    let line: Double?
    let odds: Int
    var points: Double
    var stake = 100.0
    let team: String?
    let playerID: String
    let leagueCode: String
    let timestamp: Date
    let gameID: String
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
