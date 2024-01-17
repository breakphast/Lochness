//
//  Home.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/12/24.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var createLeagueViewModel: CreateLeagueViewModel
    
    var body: some View {
        if homeViewModel.allBetOptions.isEmpty {
            Color.white
        } else {
            NavigationStack {
                TabView {
                    tab(title: "Home", icon: "home", content: Board())
                    tab(title: "My Bets", icon: "myBets", content: MyBetsView())
                    if let league = homeViewModel.activeLeague {
                        tab(title: "Scores", icon: "scores", content: LeagueDetailsView(league: league))
                            .toolbar(.hidden, for: .tabBar)
                    }
                    tab(title: "League", icon: "league", content: CreateLeagueMainView())
                }
                .tint(.main800)
                .environmentObject(homeViewModel)
                .environmentObject(betViewModel)
                .environmentObject(createLeagueViewModel)
            }
        }
    }
    
    @ViewBuilder
    private func tab<Content: View>(title: String, icon: String, content: Content) -> some View {
        content
            .tabItem {
                Image(icon)
                Text(title)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
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
}

#Preview {
    Home()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
        .environmentObject(Preview.dev.createLeagueViewModel)
}
