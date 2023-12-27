//
//  Bet.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import Foundation

struct Bet: Identifiable {
    let id = UUID()
    let type: BetType
    let result: BetResult = .pending
    let line: Double?
    let odds: Int
    var points: Double?
    let stake = 100.0
    let team: String?
    let playerID: String
    let leagueCode: String
    let timestamp: Date?
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
