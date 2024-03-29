//
//  Helpers.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/28/23.
//

import Foundation
import SwiftUI

class Helpers {
    static var decoder = JSONDecoder()
    static var encoder = JSONEncoder()
    
    init() {
        Self.decoder.dateDecodingStrategy = .iso8601
    }
    
    static func generateOrdinalStrings(upTo number: Int) -> [String] {
        var stringArray: [String] = []
        
        for i in 1...number {
            let ordinal = i
            var suffix = "th"
            
            if i == 1 {
                suffix = "st"
            } else if i == 2 {
                suffix = "nd"
            } else if i == 3 {
                suffix = "rd"
            }
            
            let string = "\(ordinal)\(suffix)"
            stringArray.append(string)
        }
        
        return stringArray
    }
    
    static let nflTeams = [
        "Miami Dolphins": "MIA Dolphins",
        "New England Patriots": "NE Patriots",
        "Buffalo Bills": "BUF Bills",
        "New York Jets": "NYJ Jets",
        "Pittsburgh Steelers": "PIT Steelers",
        "Baltimore Ravens": "BAL Ravens",
        "Cleveland Browns": "CLE Browns",
        "Cincinnati Bengals": "CIN Bengals",
        "Tennessee Titans": "TEN Titans",
        "Indianapolis Colts": "IND Colts",
        "Houston Texans": "HOU Texans",
        "Jacksonville Jaguars": "JAX Jaguars",
        "Kansas City Chiefs": "KC Chiefs",
        "Las Vegas Raiders": "LV Raiders",
        "Denver Broncos": "DEN Broncos",
        "Los Angeles Chargers": "LAC Chargers",
        "Dallas Cowboys": "DAL Cowboys",
        "Philadelphia Eagles": "PHI Eagles",
        "New York Giants": "NYG Giants",
        "Washington Commanders": "WAS Commanders",
        "Green Bay Packers": "GB Packers",
        "Chicago Bears": "CHI Bears",
        "Minnesota Vikings": "MIN Vikings",
        "Detroit Lions": "DET Lions",
        "San Francisco 49ers": "SF 49ers",
        "Seattle Seahawks": "SEA Seahawks",
        "Los Angeles Rams": "LA Rams",
        "Arizona Cardinals": "ARI Cardinals",
        "Atlanta Falcons": "ATL Falcons",
        "New Orleans Saints": "NO Saints",
        "Tampa Bay Buccaneers": "TB Buccaneers",
        "Carolina Panthers": "CAR Panthers"
    ]

    static let nflLogos = [
        "Miami Dolphins": "dolphins",
        "New England Patriots": "patriots",
        "Buffalo Bills": "bills",
        "New York Jets": "jets",
        "Pittsburgh Steelers": "steelers",
        "Baltimore Ravens": "ravens",
        "Cleveland Browns": "browns",
        "Cincinnati Bengals": "bengals",
        "Tennessee Titans": "titans",
        "Indianapolis Colts": "colts",
        "Houston Texans": "texans",
        "Jacksonville Jaguars": "jaguars",
        "Kansas City Chiefs": "chiefs",
        "Las Vegas Raiders": "raiders",
        "Denver Broncos": "broncos",
        "Los Angeles Chargers": "chargers",
        "Dallas Cowboys": "cowboys",
        "Philadelphia Eagles": "eagles",
        "New York Giants": "giants",
        "Washington Commanders": "commanders",
        "Green Bay Packers": "packers",
        "Chicago Bears": "bears",
        "Minnesota Vikings": "vikings",
        "Detroit Lions": "lions",
        "San Francisco 49ers": "49ers",
        "Seattle Seahawks": "seahawks",
        "Los Angeles Rams": "rams",
        "Arizona Cardinals": "cardinals",
        "Atlanta Falcons": "falcons",
        "New Orleans Saints": "saints",
        "Tampa Bay Buccaneers": "bucs",
        "Carolina Panthers": "panthers"
    ]
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
        print(value)
    }
}
