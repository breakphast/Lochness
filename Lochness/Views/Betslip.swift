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
    @State private var betOptionsWagered = [String]()
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
                            betCard(size, betOption: betOption)
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
                if !wager.isEmpty {
                    if let user = homeViewModel.activeUser {
                        Task {
                            for betOption in betViewModel.selectedBetOptions {
                                try await betViewModel.placeBet(betOption, user: user, wager: 100.0)
                                if betViewModel.selectedBetOptions.isEmpty {
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            } label: {
                Text("PLACE BET\(betViewModel.selectedBetOptions.count == 1 ? "" : "S") $\(wager.isEmpty ? "0.00" : wager)")
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
    
    @ViewBuilder
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
    
    @ViewBuilder
    func betCard(_ size: CGSize, betOption: BetOption) -> some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .padding(.top, 2)
                    .overlay {
                        Color.clear
                    }
                    .onTapGesture {
                        withAnimation(.snappy) {
                            betViewModel.selectedBetOptions.removeAll(where: { $0.id.uuidString == betOption.id.uuidString })
                        }
                    }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(betOption.team)
                            .fontWeight(.heavy)
                        Spacer()
                        Text(betOption.formattedOdds)
                            .fontWeight(.heavy)
                    }
                    Text(betOption.betType.rawValue + (betOption.line != nil ? " \(String(betOption.line ?? 0.0))" : ""))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .opacity(0.9)
                    Text(betOption.matchupTeamsDescription)
                        .font(.caption)
                        .opacity(0.9)
                }
                .bold()
            }
            .foregroundStyle(.white)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wager")
                        .font(.caption)
                    TextField("$0.00", text: self.$wager.dollarBinding)
                        .font(.subheadline)
                        .keyboardType(.numberPad)
                        .textContentType(.postalCode)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .stroke(.main800, lineWidth: 2)
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("To Win")
                        .font(.caption)
                    Text("$\(BetService.calculatePayout(odds: betOption.odds, wager: Double(wager) ?? 0).profit.twoDecimalString)")
                        .font(.subheadline)
                        .foregroundStyle(wager.isEmpty ? .gray.opacity(0.5) : .main900)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .stroke(.main800, lineWidth: 2)
                )
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
}

#Preview {
    Betslip()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.betViewModel)
}
