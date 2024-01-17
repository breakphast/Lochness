//
//  LeagueDetailsView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/16/24.
//

import SwiftUI

struct LeagueDetailsView: View {
    @EnvironmentObject private var betViewModel: BetViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var activeTab: LeagueDetailsTabs = .rules
    
    let league: League
    
    enum LeagueDetailsTabs: String, CaseIterable {
        case rules = "RULES"
        case prizes = "PRIZES"
        case players = "PLAYERS"
    }
    
    var body: some View {
        ZStack {
            Color.main700.ignoresSafeArea()
            GeometryReader { geo in
                let size = geo.size
                
                VStack(spacing: 16) {
                    header(size)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        mainInfoStack(size)
                        
                        switch activeTab {
                        case .rules:
                            rules(size)
                        case .prizes:
                            prizes(size)
                        case .players:
                            prizes(size)
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Join League")
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                            .foregroundStyle(.main800)
                            .background(
                                .white
                                    .shadow(.drop(color: .main500.opacity(0.5), radius: 4)), in: .rect(cornerRadius: 8)
                            )
                    }
                    .padding(.horizontal, 40)
                }
                .frame(width: size.width)
            }
        }
        .fontDesign(.rounded)
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
            Text("League Details")
        }
        .font(.title2)
        .fontWeight(.heavy)
        .foregroundStyle(.white)
    }
    private func mainInfoStack(_ size: CGSize) -> some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Silver Dollar League - Bankroll Builder")
                    .bold()
                    .foregroundStyle(.main800)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("3 of 10")
                        Text("Loched")
                            .font(.caption.bold())
                            .foregroundStyle(.main900.opacity(0.5))
                    }
                    .frame(width: size.width * 0.2, alignment: .leading)
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("$20")
                        Text("Buy-In")
                            .font(.caption.bold())
                            .foregroundStyle(.main900.opacity(0.5))
                    }
                    .frame(width: size.width * 0.2, alignment: .center)
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$4,000")
                        Text("Payouts")
                            .font(.caption.bold())
                            .foregroundStyle(.main900.opacity(0.5))
                    }
                    .frame(width: size.width * 0.2, alignment: .trailing)
                }
                .bold()
                .foregroundStyle(.main800)
                .frame(maxWidth: .infinity)
                RoundedRectangle(cornerRadius: 0.5)
                    .frame(height: 1)
                    .foregroundStyle(.main800)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text("Duration: 3 Days")
                    }
                    Spacer()
                    Text("Jan 19-21")
                }
                .font(.subheadline)
                .foregroundStyle(.main800)
                .fontWeight(.semibold)
                
                HStack(spacing: 40) {
                    ForEach(LeagueDetailsTabs.allCases, id: \.self) { tab in
                        Button {
                            withAnimation {
                                activeTab = tab
                            }
                        } label: {
                            Text(tab.rawValue)
                                .fontWeight(activeTab == tab ? .bold : .none)
                                .font(.title2)
                                .foregroundStyle(.main500)
                        }
                    }
                }
                .frame(width: size.width)
            }
            .padding()
            .frame(width: size.width, alignment: .leading)
            .background(.white)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.main100.opacity(0.3))
                .frame(height: 1)
                .shadow(color: .black, radius: 4)
        }
    }
    private func prizes(_ size: CGSize) -> some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Helpers.generateOrdinalStrings(upTo: league.size), id: \.self) { place in
                        HStack {
                            Text(place)
                                .bold()
                            Spacer()
                            Text("$\(league.size * (10 - Int(place.prefix(1))!))")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.main800)
                        RoundedRectangle(cornerRadius: 0.5)
                            .frame(height: 1)
                            .foregroundStyle(.main800.opacity(0.1))
                            .padding(.trailing, -24)
                    }
                }
                .padding()
            }
            .background(.white)
            .scrollIndicators(.hidden)
        }
    }
    private func bankrollRules(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading) {
                Text("LEAGUE MODE")
                    .foregroundStyle(.main900.opacity(0.8))
                Text("BANKROLL BUILDER")
                    .font(.title2.bold())
                    .foregroundStyle(.main900)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("HOW IT WORKS")
                    .font(.subheadline)
                    .foregroundStyle(.main900.opacity(0.8))
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(League.bankrollCreditsRules, id: \.self) { rule in
                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: "checkmark")
                                .bold()
                            Text(rule)
                        }
                        .foregroundStyle(.main900)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Examples")
                    .foregroundStyle(.main900.opacity(0.8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Starting Bankroll: $100")
                        .font(.subheadline.bold())
                    Text("Atlanta Falcons ML +200")
                    Text("$10 Wager WIN +$30")
                        .foregroundStyle(.green2)
                        .bold()
                    Text("New Bankroll: $130")
                        .bold()
                }
                
                RoundedRectangle(cornerRadius: 0.5)
                    .frame(height: 1)
                    .foregroundStyle(.main200)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Starting Bankroll: $100")
                        .font(.subheadline.bold())
                    Text("LA Lakers -3.5 -110")
                    Text("$10 Wager LOSS -$10")
                        .foregroundStyle(.red2)
                        .bold()
                    Text("New Bankroll: $90")
                        .bold()
                }
            }
        }
    }
    private func fixedRules(_ size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading) {
                Text("LEAGUE MODE")
                    .foregroundStyle(.main900.opacity(0.8))
                Text("FIXED")
                    .font(.title2.bold())
                    .foregroundStyle(.main900)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("HOW IT WORKS")
                    .font(.subheadline)
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(League.fixedBetsRules, id: \.self) { rule in
                        HStack(alignment: .top, spacing: 16) {
                            Image(systemName: "checkmark")
                                .bold()
                            Text(rule)
                        }
                        .foregroundStyle(.main900)
                    }
                }
            }
            
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Examples")
                        .foregroundStyle(.main900.opacity(0.8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("0/10 Bets Placed - 0 Points")
                            .font(.subheadline.bold())
                        Text("Atlanta Falcons ML +200")
                        Text("WIN +20 Points")
                            .foregroundStyle(.green2)
                            .bold()
                        Text("1/10 Bets Placed - 20 Points")
                            .bold()
                    }
                    
                    RoundedRectangle(cornerRadius: 0.5)
                        .frame(height: 1)
                        .foregroundStyle(.main200)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("9/10 Bets Placed - 76 Points")
                            .font(.subheadline.bold())
                        Text("LA Lakers -3.5 -110")
                        Text("LOSS 0 Points")
                            .foregroundStyle(.red2)
                            .bold()
                        Text("10/10 Bets Placed - 76 Points")
                            .bold()
                    }
                }
            }
        }
    }
    private func rules(_ size: CGSize) -> some View {
        ZStack {
            Color.white.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if league.wagerMode == WagerMode.bankroll.rawValue {
                        bankrollRules(size)
                    } else {
                        fixedRules(size)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.main100.opacity(0.3))
                .frame(height: 4)
                .shadow(color: .main900, radius: 4)
        }
    }
}

#Preview {
    LeagueDetailsView(league: League(name: "", users: [""], size: 10, sport: "NFL", leagueMode: "", wagerMode: WagerMode.bankroll.rawValue, entryFee: 20.0))
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
}
