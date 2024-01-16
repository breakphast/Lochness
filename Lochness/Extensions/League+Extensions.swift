//
//  League+Extensions.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/16/24.
//

import Foundation
import SwiftUI

extension League: CustomStringConvertible {
    var description: String {
        """
        League:
            ID: \(id)
            Name: \(name)
            Users: \(users.joined(separator: ", "))
            Size: \(size)
            Sport: \(sport)
            League Mode: \(leagueMode))
            Wager Mode: \(wagerMode)
            Playoff Mode: \(playoffMode ?? "N/A"))
            Playoff Size: \(playoffSize.map(String.init) ?? "N/A")
            Payout Structure: \(payoutStructure ?? "N/A")
            Entry Fee: \(entryFee.map { "\($0)" } ?? "N/A")
        """
    }
}
extension LeagueSizeOptions: SizeOptionRepresentable {
    var displayValue: Int { self.rawValue }
}
extension PlayoffSize: SizeOptionRepresentable {
    var displayValue: Int { self.rawValue }
}
extension LeagueMode: ModeRepresentable {
    var title: String {
        self.rawValue.capitalized
    }
    
    var secondaryText: String {
        LeagueMode.secondaryTexts[self] ?? ""
    }
    
    func isSelected(using leagueModeFromViewModel: LeagueMode) -> Bool {
        return self == leagueModeFromViewModel
    }
    
    mutating func updateSelection(newValue: Bool, in viewModel: inout CreateLeagueViewModel) {
        if newValue {
            viewModel.leagueMode = self
        }
    }
}
extension WagerMode: ModeRepresentable {
    var title: String {
        self.rawValue.capitalized
    }
    
    var secondaryText: String {
        WagerMode.secondaryTexts[self] ?? ""
    }
    
    func isSelected(using wagerModeFromViewModel: WagerMode) -> Bool {
        return self == wagerModeFromViewModel
    }
    
    mutating func updateSelection(newValue: Bool, in viewModel: inout CreateLeagueViewModel) {
        if newValue {
            viewModel.wagerMode = self
        }
    }
}

extension PayoutStructure: ModeRepresentable {
    var title: String {
        return self.rawValue.capitalized
    }
    
    var secondaryText: String {
        return PayoutStructure.secondaryTexts[self] ?? ""
    }
}

extension PlayoffMode: ModeRepresentable {
    var title: String {
        return self.rawValue.capitalized
    }
    
    var secondaryText: String {
        return PlayoffMode.secondaryTexts[self] ?? ""
    }
}
