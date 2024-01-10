//
//  MatchupRow.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import SwiftUI

struct MatchupRow: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var betViewModel: BetViewModel
    
    let game: Game
    let score: Score?
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack {
                teamStack
                Spacer()
                betButtons
            }
            Text("8:15PM ET")
                .font(.caption2)
                .foregroundStyle(.main800)
                .padding(.trailing, 4)
            
            RoundedRectangle(cornerRadius: 0.5)
                .frame(height: 1)
                .foregroundStyle(.main200)
                .padding(.leading, -24)
        }
    }
    
    private var teamStack: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let awayTeamName = Helpers.nflTeams[game.awayTeam], let awayTeamLogo = Helpers.nflLogos[game.awayTeam] {
                HStack {
                    Image(awayTeamLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36)
                    VStack(alignment: .leading) {
                        Text(awayTeamName.teamNameSplit[0])
                            .font(.caption2)
                            .foregroundStyle(.main900)
                        Text(awayTeamName.teamNameSplit[1])
                            .font(.caption.bold())
                            .foregroundStyle(.main900)
                        Text("7-9 (1L)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.main700)
                    }
                }
            }
            
            if let homeTeamName = Helpers.nflTeams[game.homeTeam], let homeTeamLogo = Helpers.nflLogos[game.homeTeam] {
                HStack {
                    Image(homeTeamLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36)
                    VStack(alignment: .leading) {
                        Text(homeTeamName.teamNameSplit[0])
                            .font(.caption2)
                            .foregroundStyle(.main900)
                        Text(homeTeamName.teamNameSplit[1])
                            .font(.caption.bold())
                            .foregroundStyle(.main900)
                        Text("11-5 (5W)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.main700)
                    }
                }
            }
        }
    }
    
    private var betButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                ForEach(homeViewModel.allBetOptions.filter({$0.game.id == game.id}).prefix(3)) { betOption in
                    BetButton(betOptionID: betOption.id.uuidString, line: betOption.formattedLine ?? nil, odds: betOption.formattedOdds)
                }
            }
            
            HStack(spacing: 8) {
                ForEach(homeViewModel.allBetOptions.filter({$0.game.id == game.id}).suffix(3)) { betOption in
                    BetButton(betOptionID: betOption.id.uuidString, line: betOption.formattedLine ?? nil, odds: betOption.formattedOdds)
                }
            }
        }
    }
}

#Preview {
    MatchupRow(game: Preview.dev.game!, score: nil)
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
}

//, selected: betViewModel.selectedBetOptions.contains(where: { $0.id == betOption.id })
