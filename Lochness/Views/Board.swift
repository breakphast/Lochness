//
//  HomeView.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import SwiftUI

struct Board: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject var betViewModel: BetViewModel
    @State private var showBetslip = false
    @State private var showMyBets = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.main500.ignoresSafeArea()
            VStack {
                header
                matchupsScrollView
            }
            if betViewModel.betslipActive {
                betslipBar
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            showBetslip.toggle()
                        }
                    }
            }
        }
        .sheet(isPresented: $showBetslip) {
            Betslip()
                .environmentObject(betViewModel)
        }
        .fullScreenCover(isPresented: $showMyBets) {
            MyBetsView()
                .environmentObject(betViewModel)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(.lochLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Text("NFL Lines")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                    .fontDesign(.rounded)
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                    Text("5 Days")
                }
                Spacer()
                HStack(spacing: 4) {
                    Text("$97.32")
                    Image(systemName: "dollarsign.circle.fill")
                }
            }
            .bold()
            .fontDesign(.rounded)
            .kerning(1.3)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
    }
    private var scrollViewHeader: some View {
        VStack {
            HStack {
                Text("Jan. 5")
                    .bold()
                
                Spacer()
                
                HStack {
                    Text("SPREAD")
                        .frame(width: 72)
                    Text("MONEY")
                        .frame(width: 72)
                    Text("TOTAL")
                        .frame(width: 72)
                }
                .font(.caption)
                .fontWeight(.semibold)
            }
            .foregroundStyle(.main800)
            .frame(maxWidth: .infinity)
            RoundedRectangle(cornerRadius: 0.5)
                .frame(height: 1)
                .foregroundStyle(.main200)
                .padding(.trailing, -24)
        }
    }
    private var matchupsScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                scrollViewHeader
                
                ForEach(homeViewModel.allGames) { game in
                    MatchupRow(game: game, score: betViewModel.allScores.first(where: {$0.id == game.id}))
                        .environmentObject(homeViewModel)
                        .environmentObject(betViewModel)
                    if game.id != homeViewModel.allGames.last?.id {
                        RoundedRectangle(cornerRadius: 0.5)
                            .frame(height: 1)
                            .foregroundStyle(.main200)
                            .padding(.leading, -24)
                    }
                }
            }
            .padding()
            .background(
                Color.white
            )
        }
    }
    private var betslipBar: some View {
        ZStack(alignment: .top) {
            Color.main500
            VStack {
                VStack(spacing: 12) {
                    Capsule()
                        .frame(width: 40, height: 3)
                        .foregroundStyle(.main200)
                    Text("BETSLIP")
                    .font(.title2.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                }
                .padding(.top, 8)
            }
        }
        .frame(height: 60)
        .clipShape(BetslipBar(radius: 12))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.main800.opacity(0.7))
                .frame(height: 1)
                .shadow(radius: 4)
        }
//        .offset(y: -49)
    }
}

#Preview {
    NavigationStack {
        Board()
            .environmentObject(Preview.dev.homeViewModel)
            .environmentObject(Preview.dev.betViewModel)
    }
}
