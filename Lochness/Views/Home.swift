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
    
    var body: some View {
        NavigationStack {
            TabView {
                tab(title: "Home", icon: "home", content: Board())
                tab(title: "My Bets", icon: "myBets", content: MyBetsView())
                tab(title: "Scores", icon: "scores", content: Text("Scores"))
                tab(title: "League", icon: "league", content: Text("League"))
            }
            .tint(.main800)
            .environmentObject(homeViewModel)
            .environmentObject(betViewModel)
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
}

#Preview {
    Home()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
}
