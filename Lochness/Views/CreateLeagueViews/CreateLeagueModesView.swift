//
//  CreateLeagueModesView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct CreateLeagueModesView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var viewModel: CreateLeagueViewModel
    
    @Binding var path: [Int]
    
    var body: some View {
        VStack(spacing: 16) {
            CreateLeagueHeader(path: $path)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("League Mode")
                    .font(.caption)
                leagueModeBox(mode: .classic)
                leagueModeBox(mode: .flex)
            }
            VStack(alignment: .leading, spacing: 16) {
                Text("Wager Mode")
                    .font(.caption)
                wagerModeBox(mode: .bankroll)
                wagerModeBox(mode: .fixed)
            }
            Spacer()
            CreateLeagueNextButton(path: $path, main: false)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    private func leagueModeBox(mode: LeagueMode) -> some View {
        HStack {
            Image(mode == viewModel.leagueMode ? .radioSelected : .radio)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(mode.rawValue.capitalized)
                    .font(.subheadline)
                    .bold()
                Text(LeagueMode.secondaryTexts[mode] ?? "")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.main900)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(mode == viewModel.leagueMode ? .main100 : .white)
                .stroke(.main700, lineWidth: 2)
        )
        .onTapGesture {
            withAnimation {
                self.viewModel.leagueMode = mode
            }
        }
    }
    private func wagerModeBox(mode: WagerMode) -> some View {
        let title: String
        let secondaryText: String
        
        switch mode {
        case .bankroll:
            title = "Bankroll"
            secondaryText = "Receive a bankroll to spend freely and build up throughout the week"
        case .fixed:
            title = "Fixed"
            secondaryText = "Receive a fixed number of bets to place on matchups per week"
        }
        
        return HStack {
            Image(mode == viewModel.wagerMode ? .radioSelected : .radio)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(secondaryText)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.main900)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(mode == viewModel.wagerMode ? .main100 : .white)
                .stroke(.main700, lineWidth: 2)
        )
        .onTapGesture {
            withAnimation {
                self.viewModel.wagerMode = mode
            }
        }
    }
}

#Preview {
    CreateLeagueModesView(path: .constant([0]))
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.createLeagueViewModel)
}
