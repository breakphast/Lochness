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
    let size: LeagueSize.RawValue
    let sport: Sport.RawValue
    let wagerMode: WagerMode.RawValue
    let playoffMode: PlayoffMode.RawValue
    let playoffSize: PlayoffSize.RawValue
    
    init(id: UUID = UUID(), name: String, users: [String], size: Int, sport: String, wagerMode: String, playoffMode: String, playoffSize: Int) {
        self.id = id
        self.name = name
        self.users = users
        self.size = size
        self.sport = sport
        self.wagerMode = wagerMode
        self.playoffMode = playoffMode
        self.playoffSize = playoffSize
    }
}

enum Sport: String {
    case nfl = "NFL"
    case nba = "NBA"
    case nhl = "NHL"
    case mlb = "MLB"
}

enum LeagueSize: Int {
    case four = 4
    case six = 6
    case eight = 8
    case ten = 10
    case twelve = 12
}

enum WagerMode: String {
    case fixed = "fixed"
    case bankroll = "bankroll"
}

enum PlayoffMode: String {
    case elimination = "elimination"
    case continuous = "continuous"
}

enum PlayoffSize: Int {
    case six = 6
    case eight = 8
}
