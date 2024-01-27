//
//  MyBetsView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/12/24.
//

import SwiftUI

struct MyBetsView: View {
    @EnvironmentObject private var betViewModel: BetViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var active = true
    @State private var activeWidth: CGFloat = 0
    @State private var settledWidth: CGFloat = 0
    @State private var activeOffset: CGFloat = 0
    @Namespace var animation
    
    var body: some View {
        ZStack {
            Color.white
            GeometryReader { geo in
                let size = geo.size
                
                VStack(spacing: 0) {
                    header(size)
                    betsScrollView(size)
                }
                .frame(width: size.width)
            }
        }
    }
    
    @ViewBuilder
    func betCard(_ size: CGSize, bet: Bet) -> some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(bet.team)
                        .fontWeight(.heavy)
                    Spacer()
                    Text(bet.formattedOdds)
                        .fontWeight(.heavy)
                }
                Text(bet.type + (bet.line != nil ? " \(String(bet.line ?? 0.0))" : ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .opacity(0.9)
                Text(bet.matchupTeamsDescription)
                    .font(.caption)
                    .opacity(0.9)
            }
            .bold()
            .foregroundStyle(.white)
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("$\(bet.wager.twoDecimalString)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .keyboardType(.numberPad)
                        .textContentType(.postalCode)
                    Text("WAGER")
                        .font(.caption)
                        .foregroundStyle(.main200)
                        .kerning(0.5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("$\(bet.payout?.twoDecimalString ?? 0.0.oneDecimalString)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Text("PAYOUT")
                        .font(.caption)
                        .foregroundStyle(.main200)
                        .kerning(0.5)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.main500)
                .stroke(.main800, lineWidth: 2)
        )
        .padding(.horizontal)
    }
    private func header(_ size: CGSize) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Bets")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.main800)
                Spacer()
                Image(.lochLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            HStack(spacing: 4) {
                Text("Bankroll: $230.34")
                Text("(+130.34)")
                    .foregroundStyle(.main700)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.caption.bold())
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Active")
                        .opacity(active ? 1 : 0.7)
                        .kerning(0.7)
                        .background(GeometryReader { geometry in
                            Color.clear.preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                        })
                    
                    if active {
                        RoundedRectangle(cornerRadius: 1.5)
                            .frame(width: activeWidth, height: 3)
                            .matchedGeometryEffect(id: "underline", in: animation)
                    }
                }
                .onPreferenceChange(WidthPreferenceKey.self) { width in
                    activeWidth = width
                    activeOffset = 0 // Active is the first item
                }
                .onTapGesture {
                    withAnimation {
                        active = true
                    }
                }
                
                VStack(spacing: 4) {
                    Text("Settled")
                        .opacity(active ? 0.7 : 1)
                        .kerning(0.7)
                        .background(GeometryReader { geometry in
                            Color.clear.preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                        })
                    
                    if !active {
                        RoundedRectangle(cornerRadius: 1.5)
                            .frame(width: settledWidth, height: 3)
                            .matchedGeometryEffect(id: "underline", in: animation)
                    }
                }
                .onPreferenceChange(WidthPreferenceKey.self) { width in
                    settledWidth = width
                    activeOffset = activeWidth + 24 // Assuming 24 is the HStack spacing
                }
                .onTapGesture {
                    withAnimation {
                        active = false
                    }
                }
            }
            .foregroundStyle(.main700)
            .bold()
            .frame(width: size.width / 2, alignment: .center)
        }
        .padding(.horizontal, 24)
    }
    private func betsScrollView(_ size: CGSize) -> some View {
        ScrollView {
            if let user = homeViewModel.activeUser {
                VStack(spacing: 8) {
                    ForEach(betViewModel.allBets.filter({$0.userID == user.id.uuidString}), id: \.id) { bet in
                        betCard(size, bet: bet)
                    }
                }
                .padding(.top, 24)
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MyBetsView()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
}
