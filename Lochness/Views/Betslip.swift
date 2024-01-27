//
//  MyBets.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/10/24.
//

import SwiftUI

struct Betslip: View {
    @EnvironmentObject private var betViewModel: BetViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var wager = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white
            GeometryReader { geo in
                let size = geo.size
                
                VStack(spacing: 0) {
                    betslipHeader(size)
                    ScrollView {
                        ForEach(betViewModel.selectedBetOptions, id: \.id) { betOption in
                            BetCard(betOption: betOption)
                        }
                        .padding(.top, 24)
                    }
                    .scrollIndicators(.hidden)
                    
                    placeBetContainer(size)
                }
                .frame(width: size.width)
            }
        }
    }
    
    @ViewBuilder
    func placeBetContainer(_ size: CGSize) -> some View {
        ZStack {
            Color.white.ignoresSafeArea()
                .shadow(radius: 2)
            Button {
                if let user = homeViewModel.activeUser {
                    Task {
                        for bet in betViewModel.readyBets {
                            try await betViewModel.placeBet(bet, user: user, wager: bet.wager)
                            if betViewModel.readyBets.isEmpty && betViewModel.selectedBetOptions.isEmpty {
                                dismiss()
                            }
                        }
                    }
                }
            } label: {
                Text("PLACE BET\(betViewModel.selectedBetOptions.count == 1 ? "" : "S") $\(betViewModel.totalWager.twoDecimalString)")
                    .foregroundStyle(.white)
                    .font(.headline.bold())
                    .kerning(1.0)
            }
            .frame(width: size.width)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.main700)
                    .padding(.horizontal, 24)
            )
        }
        .frame(height: 80)
        .overlay {
            Rectangle()
                .fill(.main800.opacity(0.75))
                .frame(height: 2)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    func betslipHeader(_ size: CGSize) -> some View {
        HStack(spacing: 8) {
            Text("Betslip")
            Circle()
                .fill(.white)
                .frame(width: 24)
                .overlay {
                    Text("\(betViewModel.selectedBetOptions.count)")
                        .font(.caption2)
                        .foregroundStyle(.main700)
                }
        }
        .foregroundStyle(.white)
        .fontWeight(.heavy)
        .padding()
        .padding(.leading, 4)
        .frame(width: size.width, alignment: .leading)
        .background(
            Color.main700
                .shadow(.drop(radius: 8))
        )
        .overlay {
            Rectangle()
                .fill(.main800.opacity(0.75))
                .frame(height: 2)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    Betslip()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
}
