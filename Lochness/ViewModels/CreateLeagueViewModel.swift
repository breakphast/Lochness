//
//  CreateLeagueViewModel.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import Foundation

class CreateLeagueViewModel: ObservableObject {
    @Published var leagueName: String = ""
    @Published var leagueSize: Int = 4
    @Published var leagueSport = "Select Sport"
    
    @Published var wagerMode: WagerMode = .bankroll
    @Published var playoffMode: PlayoffMode? = nil
    @Published var leagueMode: LeagueMode = .classic
    
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
}

enum LeagueCreationStep: CaseIterable {
    case main
    case mode
    case payout
    case playoff
}
