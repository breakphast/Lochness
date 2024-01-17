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
    
    static var fixedBetsRules: [String] = [
        "Each player is given a fixed amount of bets upon joining a contest, which can be placed on the league’s focused sport over the scheduled duration.",
        "Bets can be placed on spreads, moneylines, and totals.",
        "Each bet is scored on a 10-point scale, adjusted according to the result and odds.",
        "You must use all your bets; otherwise, your final score will be deducted 10 points for each unused bet."
    ]

    // Bankroll Credits Rules
    static var bankrollCreditsRules: [String] = [
        "Each player receives $100 in bankroll credits.",
        "The objective is to increase your bankroll as much as possible during the duration of the league.",
        "The top 3 players with the highest percentage change in their bankroll are paid out accordingly.",
        "Place bets for the league’s focused sport using your bankroll during the day(s) of your league’s schedule.",
        "You must wager at least $100 in total during the league's duration; otherwise, the unused amount will be deducted from your final bankroll.",
        "Winnings from bets are added to your bankroll and can be used to place new bets, following the structure of traditional betting.",
        "If your bankroll reaches $0 with no active bets, that becomes your final score, and you can no longer place bets."
    ]
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
