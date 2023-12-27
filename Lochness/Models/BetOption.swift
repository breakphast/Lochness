//
//  BetOption.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import Foundation

class BetOption: Identifiable {
    let id = UUID()
    let game: Game
    let betType: BetType
    var odds: Int
    var line: Double? = nil
    var betString: String
    var selectedTeam: String? = nil
    
    init(game: Game, betType: BetType, odds: Int, line: Double? = nil, selectedTeam: String? = nil) {
        self.game = game
        self.betType = betType
        self.odds = odds
        
        let formattedOdds = odds > 0 ? "+\(odds)" : "\(odds)"
        
        switch betType {
        case .spread:
            if let line = line {
                let formattedSpread = line > 0 ? "+\(line)" : "\(line)"
                betString = "\(formattedSpread)\n\(formattedOdds)"
            } else {
                betString = ""
            }
        case .moneyline:
            betString = formattedOdds
        case .over:
            betString = "O \(line ?? 0)\n\(formattedOdds)"
        case .under:
            betString = "U \(line ?? 0)\n\(formattedOdds)"
        }
    }
}
