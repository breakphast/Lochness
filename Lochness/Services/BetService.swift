//
//  BetService.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import Foundation
import SwiftUI
import Combine

class BetService {
    @Published var allBets = [Bet]()
        
    public func makeBet(from betOption: BetOption) {
        let bet = Bet(type: betOption.betType, line: betOption.line ?? nil, odds: betOption.odds, team: betOption.selectedTeam ?? nil, playerID: "1234", leagueCode: "1234", timestamp: Date())
        
        self.allBets.append(bet)
        print(self.allBets.count)
    }
}
