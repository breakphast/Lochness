//
//  HomeView.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.7).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(vm.allGames) { game in
                        MatchupRow(game: game, score: vm.allScores.first(where: {$0.id == game.id}))
                            .environmentObject(vm)
                        
                        Divider()
                            .foregroundStyle(.primary)
                    }
                }
                .padding()
            }
        }
    }
    
    private var betsListing: some View {
        ForEach(vm.allBets) { bet in
            VStack(alignment: .leading) {
                Text(bet.type != .moneyline ? "\(bet.type) \(bet.line ?? 0.0)" : bet.type.rawValue)
                Text(String(bet.odds))
                Text(bet.team ?? "")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
            )
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(Preview.dev.homeVM)
}
