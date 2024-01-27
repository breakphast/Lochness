//
//  Tab.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/17/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case myBets = "My Bets"
    case scores = "Scores"
    case league = "League"
    
    var icon: String {
        switch self {
        case .home:
            self == .home ? "home" : "league"
        case .myBets:
            "myBets"
        case .scores:
            "scores"
        case .league:
            "league"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}
