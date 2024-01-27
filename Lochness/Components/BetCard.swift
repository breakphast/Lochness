//
//  BetCard.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/27/24.
//

import SwiftUI

struct BetCard: View {
    @EnvironmentObject private var betViewModel: BetViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    let betOption: BetOption
    @State private var wager = ""
    
    var body: some View {
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
        .onChange(of: wager) {
            betViewModel.readyBets.removeAll(where: { $0.id == betOption.id })
            
            guard
                let activeUser = homeViewModel.activeUser,
                let activeLeague = homeViewModel.activeLeague
            else { return }
            
            betViewModel.readyBets.append(BetService().makeBet(from: betOption, user: activeUser, league: activeLeague.id.uuidString, wager: Double(wager) ?? 0))
        }
    }
}

//#Preview {
//    BetCard()
//        .environmentObject(Preview.dev.homeViewModel)
//        .environmentObject(Preview.dev.betViewModel)
//}
