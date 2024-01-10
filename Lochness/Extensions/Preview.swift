//
//  Preview.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/27/23.
//

import Foundation
import SwiftUI

extension Preview {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    let game: Game?
    let bet: Bet?
    let homeViewModel = HomeViewModel()
    let betViewModel = BetViewModel()
    
    private init() {
        let gameElement = GameElement(
            id: "856010af3973ce10b0dd20f7dfc50fb6",
            sportKey: .americanfootball_nfl,
            sportTitle: .NFL,
            commenceTime: Date(timeIntervalSince1970: 1672278900),
            completed: false,
            homeTeam: "Cleveland Browns",
            awayTeam: "New York Jets",
            bookmakers: [
                Bookmaker(
                    key: .fanduel,
                    title: .fanDuel,
                    lastUpdate: Date(timeIntervalSince1970: 1672149307),
                    markets: [
                        Market(
                            key: .h2H,
                            lastUpdate: Date(timeIntervalSince1970: 1672149307),
                            outcomes: [
                                Outcome(name: "Cleveland Browns", price: -335, point: nil),
                                Outcome(name: "New York Jets", price: 270, point: nil)
                            ]
                        ),
                        Market(
                            key: .spreads,
                            lastUpdate: Date(timeIntervalSince1970: 1672149307),
                            outcomes: [
                                Outcome(name: "Cleveland Browns", price: -115, point: -7.0),
                                Outcome(name: "New York Jets", price: -105, point: 7.0)
                            ]
                        ),
                        Market(
                            key: .totals,
                            lastUpdate: Date(timeIntervalSince1970: 1672149307),
                            outcomes: [
                                Outcome(name: "Over", price: -114, point: 34.5),
                                Outcome(name: "Under", price: -106, point: 34.5)
                            ]
                        )
                    ]
                )
            ]
        )
        self.game = Game(gameElement: gameElement)
        let options = GameService().generateBetOptions(game: self.game!)
        self.bet = BetService().makeBet(from: options[0], user: User(username: "JONATHAN"), league: nil, contest: nil)
        betViewModel.selectedBetOptions = [options[4]]
    }
}
