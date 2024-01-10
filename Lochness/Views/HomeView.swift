//
//  HomeView.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject var betViewModel: BetViewModel
    @State private var showBetslip = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.main500.ignoresSafeArea()
                VStack {
                    header
                    betsScrollView
                }
                
                if betViewModel.betslipActive {
                    betslipBar
                        .padding(.bottom, 60)
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                showBetslip.toggle()
                            }
                        }
                }
                
                tabBar
            }
            .overlay {
                Color.black.opacity(showBetslip ? 0.5 : 0).ignoresSafeArea()
            }
            .sheet(isPresented: $showBetslip) {
                Betslip()
                    .environmentObject(betViewModel)
            }
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
                    .font(.title2.bold())
                    .fontDesign(.rounded)
            }
            
            HStack {
                Text("Loch League")
                    .frame(width: 80)
                    .lineLimit(1)
                    .font(.caption)
                    .fontWeight(.semibold)
                Spacer()
                Text("$97.32")
                    .frame(width: 120)
                    .font(.title2.bold())
                    .fontDesign(.rounded)
                    .kerning(1.3)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("5 Days")
                }
                .frame(width: 80)
                .font(.caption)
                .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
    }
    private var splashScreen: some View {
        ZStack {
            Color.main300
                .ignoresSafeArea()
            
            Image(.lochLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
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
    private var betsScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                scrollViewHeader
                
                ForEach(homeViewModel.allGames) { game in
                    MatchupRow(game: game, score: betViewModel.allScores.first(where: {$0.id == game.id}))
                        .environmentObject(homeViewModel)
                        .environmentObject(betViewModel)
                }
            }
            .padding()
            .background(
                Color.white
            )
        }
    }
    private var tabBar: some View {
        ZStack() {
            Color.white.ignoresSafeArea()
                .shadow(radius: 8)
            HStack {
                TabBarButton(image: Image(.home), title: "Home")
                Spacer()
                TabBarButton(image: Image(.myBets), title: "My Bets")
                Spacer()
                TabBarButton(image: Image(.scores), title: "Scores")
                Spacer()
                TabBarButton(image: Image(.league), title: "League")
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
        }
        .frame(height: 60)
    }
    private var placeBetContainer: some View {
        ZStack {
            Color.white.ignoresSafeArea()
                .shadow(radius: 8)
            Text("Place Bets $240")
                .frame(maxWidth: .infinity)
        }
        .frame(height: 60)
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
        .shadow(radius: 10)
    }
    
    private var betCard: some View {
        VStack {
            HStack {
                Image(systemName: "xmark")
                    .fontDesign(.rounded)
                    .bold()
                    .frame(maxHeight: .infinity, alignment: .top)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Chicago Bears")
                            .font(.caption.bold())
                        Spacer()
                        Text("+120")
                            .font(.caption.bold())
                    }
                    Spacer()
                    
                    Text("Moneyline")
                        .font(.caption2)
                    Spacer()
                    Text("Chicago Bears @ Green Bay Packers")
                        .font(.caption2.bold())
                    Spacer()
                }
            }
            .foregroundStyle(.white)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Wager")
                    Text("$80.00")
                }
                .frame(maxWidth: .infinity)
                .font(.caption)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .stroke(.main800, lineWidth: 2)
                )
                
                VStack(alignment: .leading) {
                    Text("Wager")
                    Text("$80.00")
                }
                .frame(maxWidth: .infinity)
                .font(.caption)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .stroke(.main800, lineWidth: 2)
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(height: 160)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.main700)
                .stroke(.main800, lineWidth: 2)
        )
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(Preview.dev.homeViewModel)
            .environmentObject(Preview.dev.betViewModel)
    }
}
