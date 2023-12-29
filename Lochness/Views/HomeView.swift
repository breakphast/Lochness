//
//  HomeView.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showBets = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.opacity(0.7).ignoresSafeArea()
            
            Button {
                showBets.toggle()
            } label: {
                Text("Bets")
                    .font(.largeTitle.bold())
                    .padding(.horizontal, 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            .zIndex(1000)
            
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
        .sheet(isPresented: $showBets) {
            betsListing
        }
    }
    
    private var betsListing: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(vm.allBets.filter({$0.userID == vm.activeUser?.id.uuidString})) { bet in
                    ZStack {
                        BetComponent(bet: bet)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button("Delete") {
                            Task {
                                try await vm.deleteBet(bet)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Divider()
                        .foregroundStyle(.primary)
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(Preview.dev.homeVM)
}
