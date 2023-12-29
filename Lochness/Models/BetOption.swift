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
    var buttonText: String
    var team: String
    
    init(game: Game, betType: BetType, odds: Int, line: Double? = nil, team: String) {
        self.game = game
        self.betType = betType
        self.odds = odds
        self.team = team
        
        let formattedOdds = odds > 0 ? "+\(odds)" : "\(odds)"
        
        if let line {
            self.line = line
        }
        
        switch betType {
        case .spread:
            if let line = line {
                let formattedSpread = line > 0 ? "+\(line)" : "\(line)"
                buttonText = "\(formattedSpread)\n\(formattedOdds)"
            } else {
                buttonText = ""
            }
        case .moneyline:
            buttonText = formattedOdds
        case .over:
            buttonText = "O \(line ?? 0)\n\(formattedOdds)"
        case .under:
            buttonText = "U \(line ?? 0)\n\(formattedOdds)"
        }
    }
}
