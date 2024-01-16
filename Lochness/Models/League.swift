//
//  League.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/2/24.
//

import Foundation
import SwiftUI

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
        .flex : "Join quick, variable-duration leagues for fast-paced, adaptable play"
    ]
}

enum WagerMode: String {
    case fixed = "fixed"
    case bankroll = "bankroll builder"
    
    static let secondaryTexts: [WagerMode: String] = [
        .bankroll: "Receive a starting bankroll to spend freely and build upon throughout the league's set duration",
        .fixed: "Receive a fixed amount of bets to place in attempt to earn points"
    ]
}

enum PayoutStructure: String {
    case topHeavy = "top-Heavy"
    case balanced = "balanced"
    
    static let secondaryTexts: [PayoutStructure: String] = [
        .topHeavy : "Winner takes most, with significant rewards for first place and smaller prizes for runners-up",
        .balanced : "Equitable distribution of winnings, with first place earning more but a fair share for others."
    ]
}

enum PlayoffMode: String {
    case elimination = "elimination"
    case continuous = "continuous"
    
    static let secondaryTexts: [PlayoffMode: String] = [
        .elimination : "Lowest scoring players are eliminated each week",
        .continuous : "Points are tallied over several weeks"
    ]
}

enum PlayoffSize: Int, CaseIterable {
    case two = 2
    case four = 4
    case six = 6
    case eight = 8
}

protocol SizeOptionRepresentable: Hashable {
    var displayValue: Int { get }
}

protocol ModeRepresentable {
    var title: String { get }
    var secondaryText: String { get }
}
