//
//  Game.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import Foundation

enum MarketKey: String, Codable {
    case h2H = "h2h"
    case spreads = "spreads"
    case totals = "totals"
}

// MARK: - Outcome
struct Outcome: Codable {
    let name: String
    let price: Int
    let point: Double?
}

class Game: Identifiable, Codable {
    let id, homeTeam, awayTeam: String
    var date: Date
    var completed: Bool
    
    var awaySpreadLine: Double
    var awaySpreadOdds: Double
    var homeSpreadLine: Double
    var homeSpreadOdds: Double

    var homeMoneyLineOdds: Int
    var awayMoneyLineOdds: Int
    
    var overLine: Double
    var overOdds: Double
    var underLine: Double
    var underOdds: Double
    
    init(gameElement: GameElement) {
        var homeSpreadTemp: Double = 0.0
        var awaySpreadTemp: Double = 0.0
        var homeMoneyLineTemp: Int = 0
        var awayMoneyLineTemp: Int = 0
        var overTemp: Double = 0.0
        var underTemp: Double = 0.0
        var homeSpreadPriceTemp: Double = 0.0
        var awaySpreadPriceTemp: Double = 0.0
        var overPriceTemp: Double = 0.0
        var underPriceTemp: Double = 0.0

        if let fanduel = gameElement.bookmakers?.first(where: { $0.key == .fanduel }) {
            fanduel.markets.forEach { market in
                switch market.key {
                case .h2H:
                    market.outcomes.forEach { outcome in
                        if outcome.name == gameElement.homeTeam {
                            homeMoneyLineTemp = outcome.price
                        } else if outcome.name == gameElement.awayTeam {
                            awayMoneyLineTemp = outcome.price
                        }
                    }
                case .spreads:
                    market.outcomes.forEach { outcome in
                        if outcome.name == gameElement.homeTeam {
                            homeSpreadTemp = outcome.point ?? 0.0
                            homeSpreadPriceTemp = Double(outcome.price)
                        } else if outcome.name == gameElement.awayTeam {
                            awaySpreadTemp = outcome.point ?? 0.0
                            awaySpreadPriceTemp = Double(outcome.price)
                        }
                    }
                case .totals:
                    market.outcomes.forEach { outcome in
                        if outcome.name == "Over" {
                            overTemp = outcome.point ?? 0.0
                            overPriceTemp = Double(outcome.price)
                        } else if outcome.name == "Under" {
                            underTemp = outcome.point ?? 0.0
                            underPriceTemp = Double(outcome.price)
                        }
                    }
                }
            }
        }
        
        // Initializing properties
        self.id = gameElement.id
        self.homeTeam = gameElement.homeTeam
        self.awayTeam = gameElement.awayTeam
        self.date = gameElement.commenceTime
        self.completed = gameElement.completed ?? false
        
        self.homeMoneyLineOdds = homeMoneyLineTemp
        self.awayMoneyLineOdds = awayMoneyLineTemp
        
        self.homeSpreadLine = homeSpreadTemp
        self.homeSpreadOdds = homeSpreadPriceTemp

        self.awaySpreadLine = awaySpreadTemp
        self.awaySpreadOdds = awaySpreadPriceTemp

        self.overLine = overTemp
        self.overOdds = overPriceTemp

        self.underLine = underTemp
        self.underOdds = underPriceTemp
    }
}

// MARK: - GameElement
struct GameElement: Codable, CustomStringConvertible {
    let id: String
    let sportKey: SportKey
    let sportTitle: SportTitle
    let commenceTime: Date
    let completed: Bool?
    let homeTeam, awayTeam: String
    let bookmakers: [Bookmaker]?

    enum CodingKeys: String, CodingKey {
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case completed
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case bookmakers
    }
    
    var description: String {
        return "GameElement(id: \(id), sportKey: \(sportKey), sportTitle: \(sportTitle), commenceTime: \(commenceTime), completed: \(completed ?? false), homeTeam: \(homeTeam), awayTeam: \(awayTeam), bookmakers: \(bookmakers ?? [])"
    }
}

// MARK: - Bookmaker
struct Bookmaker: Codable {
    let key: BookmakerKey
    let title: Title
    let lastUpdate: Date
    let markets: [Market]

    enum CodingKeys: String, CodingKey {
        case key, title
        case lastUpdate = "last_update"
        case markets
    }
}

enum BookmakerKey: String, Codable {
    case fanduel = "fanduel"
}

// MARK: - Market
struct Market: Codable {
    let key: MarketKey
    let lastUpdate: Date
    let outcomes: [Outcome]

    enum CodingKeys: String, CodingKey {
        case key
        case lastUpdate = "last_update"
        case outcomes
    }
}

struct NFLWeek {
    let weekNumber: Int
    let startDate: Date
    let endDate: Date
}

enum Title: String, Codable {
    case fanDuel = "FanDuel"
}

enum SportKey: String, Codable {
    case americanfootball_nfl = "americanfootball_nfl"
    case baseball_mlb = "baseball_mlb"
}

enum SportTitle: String, Codable {
    case NFL = "NFL"
    case MLB = "MLB"
}
