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
    @State private var activeTab: Tab = .home
    
    var body: some View {
        if homeViewModel.activeLeague == nil {
            MyLeaguesView()
        } else {
            NavigationStack {
                TabView {
                    tab(tab: .home, content: Board())
                        .tag(Tab.home)
                    tab(tab: .myBets, content: MyBetsView())
                        .tag(Tab.myBets)
                    tab(tab: .scores, content: MainWebView())
                        .tag(Tab.scores)
                    tab(tab: .league, content: LeagueDetailsView(league: homeViewModel.activeLeague!))
                        .tag(Tab.league)
                }
                .tint(.main800)
                .environmentObject(homeViewModel)
                .environmentObject(betViewModel)
                .environmentObject(createLeagueViewModel)
            }
        }
    }
    
    @ViewBuilder
    private func tab<Content: View>(tab: Tab, content: Content) -> some View {
        content
            .tabItem {
                Image(tab.icon)
                Text(tab.rawValue)
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

struct TabItem: View {
    var tab: Tab
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 6) {
            Image(tab.icon)
            Text(tab.rawValue)
        }
    }
}

#Preview {
    Home()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
        .environmentObject(Preview.dev.createLeagueViewModel)
}
