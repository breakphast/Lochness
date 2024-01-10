//
//  BetElement.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/29/23.
//

import Foundation
import SwiftUI

struct BetComponent: View {
    let bet: Bet
    let typeDescription: String?
    
    init(bet: Bet) {
        self.bet = bet
        
        switch self.bet.type {
        case BetType.over.rawValue, BetType.under.rawValue:
            self.typeDescription = "Totals"
        default:
            self.typeDescription = bet.type
        }
    }
    
    private var formattedOdds: String {
        bet.odds > 0 ? "+\(bet.odds)" : "\(bet.odds)"
    }
    
    private var line: String? {
        if let line = bet.line {
            return String(line)
        } else {
            return nil
        }
    }
    
    private var description: String {
        if let line {
            return "\(line) \(formattedOdds)"
        } else {
            return String(formattedOdds)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(bet.team)
            if let typeDescription {
                Text(typeDescription)
            }
            Text(description)
        }
    }
}

extension Bet {
    var formattedOdds: String {
        odds > 0 ? "+\(odds)" : "\(odds)"
    }
    
    var formattedLine: String? {
        if let line = line {
            return line > 0 ? "+\(line)" : "\(line)"
        } else {
            return nil
        }
    }
}

extension BetOption {
    var formattedOdds: String {
        odds > 0 ? "+\(odds)" : "\(odds)"
    }
    
    var formattedLine: String? {
        if let line = line {
            switch betType {
            case .spread:
                return line > 0 ? "+\(line)" : "\(line)"
            case .over:
                return "O \(line)"
            case .under:
                return "U \(line)"
            default: return nil
            }
        } else {
            return nil
        }
    }
}
