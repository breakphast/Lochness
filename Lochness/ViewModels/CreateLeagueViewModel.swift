//
//  CreateLeagueViewModel.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import Foundation

class CreateLeagueViewModel: ObservableObject {
    @Published var leagueName: String = ""
    @Published var leagueSize: LeagueSizeOptions = .eight
    @Published var leagueSport = "Select Sport"
    @Published var leagueMode: LeagueMode = .classic
    @Published var wagerMode: WagerMode = .bankroll
    
    @Published var playoffMode: PlayoffMode = .elimination
    @Published var playoffSize: PlayoffSize = .two
    @Published var payoutStructure: PayoutStructure = .topHeavy
    @Published var entryFee: Double = 0.0
    @Published var path: [Int] = []
        
    func mainAppend() {
        guard leagueName.count > 4 && SportOptions(rawValue: leagueSport) != nil else {
            print("Need valid league name and sport.")
            return
        }
        path.append(path.count)
    }
    
    func childAppend() {
        path.append(path.count)
    }
    
    func createLeague() {
        let league = LeagueService().makeLeague(
            name: leagueName,
            userID: "2m1k2m1k",
            size: leagueSize.rawValue,
            sport: leagueSport,
            leagueMode: leagueMode.rawValue,
            wagerMode: wagerMode.rawValue,
            playoffMode: leagueMode == .classic ? playoffMode.rawValue : nil,
            playoffSize: leagueMode == .classic ? playoffSize.rawValue : nil,
            payoutStructure: leagueMode == .flex ? payoutStructure.rawValue : nil,
            entryFee: leagueMode == .flex ? entryFee : nil
        )
        print(league.description)
    }
}

enum LeagueCreationStep: CaseIterable {
    case main
    case mode
    case payout
    case playoff
}
