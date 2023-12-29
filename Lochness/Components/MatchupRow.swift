//
//  MatchupRow.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import SwiftUI

struct MatchupRow: View {
    @EnvironmentObject var vm: HomeViewModel
    
    let game: Game
    let score: Score?
    
    var body: some View {
        HStack {
            teams
            Spacer()
            betButtons
        }
    }
    
    private var teams: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(game.awayTeam)
                Text(score?.awayScore ?? "")
                    .bold()
            }
            Text("@")
            HStack {
                Text(game.homeTeam)
                Text(score?.homeScore ?? "")
                    .bold()
            }
        }
        .font(.caption)
    }
    
    private var betButtons: some View {
        VStack {
            HStack {
                ForEach(vm.allBetOptions.filter({$0.game.id == game.id}).prefix(3)) { betOption in
                    Button {
                        Task {
                            try await vm.addBet(from: betOption)
                        }
                    } label: {
                        Text(betOption.buttonText)
                            .font(.caption2.bold())
                            .frame(width: 48, height: 44)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                }
            }
            HStack {
                ForEach(vm.allBetOptions.filter({$0.game.id == game.id}).suffix(3)) { betOption in
                    Button {
                        Task {
                            try await vm.addBet(from: betOption)
                        }
                    } label: {
                        Text(betOption.buttonText)
                            .font(.caption2.bold())
                            .frame(width: 48, height: 44)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                }
            }
        }
    }
}

//#Preview {
//    BetButtons()
//}
