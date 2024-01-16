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
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("League Mode")
                        .font(.caption.bold())
                    ModeBox(selectedMode: $viewModel.leagueMode, mode: .classic)
                    ModeBox(selectedMode: $viewModel.leagueMode, mode: .flex)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wager Mode")
                        .font(.caption.bold())
                    ModeBox(selectedMode: $viewModel.wagerMode, mode: .bankroll)
                    ModeBox(selectedMode: $viewModel.wagerMode, mode: .fixed)
                }
            }
            
            Spacer()
            CreateLeagueNextButton(path: $path)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CreateLeagueModesView(path: .constant([0]))
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.createLeagueViewModel)
}

