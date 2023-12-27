//
//  Score.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/27/23.
//

import Foundation
import SwiftUI

class Score: Identifiable, Codable {
    let id: String
    let homeTeam: String
    let awayTeam: String
    var date: Date
    var completed: Bool
    var homeScore: String?
    var awayScore: String?

    init(scoreElement: ScoreElement) {
        self.id = scoreElement.id
        self.homeTeam = scoreElement.homeTeam
        self.awayTeam = scoreElement.awayTeam
        self.date = scoreElement.commenceTime
        self.completed = scoreElement.completed

        if let scores = scoreElement.scores, scores.count >= 2 {
            self.homeScore = scores.first { $0.name == scoreElement.homeTeam }?.score
            self.awayScore = scores.first { $0.name == scoreElement.awayTeam }?.score
        }
    }
}

struct ScoreElement: Codable {
    let id: String
    let sportKey: String
    let sportTitle: String
    let commenceTime: Date
    let completed: Bool
    let homeTeam: String
    let awayTeam: String
    let scores: [ScoreChild]?
    let lastUpdate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case scores
        case completed
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case lastUpdate = "last_update"
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
    }
}

struct ScoreChild: Codable {
    let name: String
    let score: String?
}
