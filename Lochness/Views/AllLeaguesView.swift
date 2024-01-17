//
//  AllLeaguesView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/16/24.
//

import SwiftUI

struct AllLeaguesView: View {
    @EnvironmentObject private var betViewModel: BetViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white
            GeometryReader { geo in
                let size = geo.size
                
                VStack(spacing: 0) {
                    header(size)
                    if homeViewModel.allLeagues.isEmpty {
                        Text("No Leagues")
                            .padding(.top, 120)
                            .bold()
                            .foregroundStyle(.main800)
                    } else {
                        leaguesScrollView(size)
                    }
                }
                .frame(width: size.width)
            }
        }
    }
    
    @ViewBuilder
    private func header(_ size: CGSize) -> some View {
        ZStack {
            Image(systemName: "xmark")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .onTapGesture {
                    dismiss()
                }
            Text("Available Leagues")
                .font(.title3)
        }
        .fontWeight(.bold)
        .fontDesign(.rounded)
        .foregroundStyle(.main800)
    }
    func leagueCard(_ size: CGSize, league: League) -> some View {
        Button {
            Task {
                try await homeViewModel.addUserToLeague(league: league)
            }
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                // name and icon
                HStack {
                    Text("\(league.name) - \(league.wagerMode.capitalized)")
                    .fontWeight(.bold)
                    Spacer()
                    Image(.moneyBag)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("2 of 10")
                        Text("Entries")
                            .font(.caption)
                            .foregroundStyle(.main100)
                            .fontWeight(.none)
                    }
                    Spacer()
                    VStack {
                        Text("$50")
                        Text("Entry Fee")
                            .font(.caption)
                            .foregroundStyle(.main100)
                            .fontWeight(.none)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("3 Days")
                        Text("Duration")
                            .font(.caption)
                            .foregroundStyle(.main100)
                            .fontWeight(.none)
                    }
                }
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.main500)
                    .stroke(.main800, lineWidth: 2)
            )
            .padding(.horizontal)
        }
    }
    
    private func leaguesScrollView(_ size: CGSize) -> some View {
        ScrollView {
            if let _ = homeViewModel.activeUser {
                VStack(spacing: 8) {
                    ForEach(homeViewModel.allLeagues, id: \.id) { league in
                        leagueCard(size, league: league)
                        leagueCard(size, league: league)
                        leagueCard(size, league: league)
                        leagueCard(size, league: league)
                        leagueCard(size, league: league)
                    }
                }
                .padding(.top, 24)
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    AllLeaguesView()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
}
