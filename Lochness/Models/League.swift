//
//  League.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/2/24.
//

import Foundation

class League: Identifiable, Codable {
    var id = UUID()
    var name: String
    var users: [String]
    
    let size: Int
    let sport: String
    
    let leagueMode: String
    let wagerMode: String
    
    var playoffMode: String? = nil
    var playoffSize: Int? = nil
    
    var payoutStructure: String? = nil
    var entryFee: Double? = nil
    
    init(id: UUID = UUID(), name: String, users: [String], size: Int, sport: String, leagueMode: String, wagerMode: String, playoffMode: String? = nil, playoffSize: Int? = nil, payoutStructure: String? = nil, entryFee: Double? = nil) {
        self.id = id
        self.name = name
        self.users = users
        self.size = size
        self.sport = sport
        self.leagueMode = leagueMode
        self.wagerMode = wagerMode
        self.playoffMode = playoffMode
        self.playoffSize = playoffSize
        self.payoutStructure = payoutStructure
        self.entryFee = entryFee
    }
}

enum SportOptions: String, CaseIterable {
    case nfl = "NFL"
    case nba = "NBA"
    case nhl = "NHL"
    case mlb = "MLB"
}

enum LeagueSizeOptions: Int, CaseIterable {
    case four = 4
    case six = 6
    case eight = 8
    case ten = 10
    case twelve = 12
}

enum LeagueMode: String {
    case classic = "classic"
    case flex = "flex"
    
    static let secondaryTexts: [LeagueMode: String] = [
        .classic : "Compete in a full season league for long-term strategy and engagement",
        .flex : "Join quick, variable-duration leagues for fast-paced, adaptable play."
    ]
}

enum WagerMode: String {
    case fixed = "fixed"
    case bankroll = "bankroll"
}

enum PayoutStructure: String {
    case topHeavy = "top-Heavy"
    case balanced = "balanced"
}

enum PlayoffMode: String {
    case elimination = "elimination"
    case continuous = "continuous"
}

enum PlayoffSize: Int {
    case six = 6
    case eight = 8
}
