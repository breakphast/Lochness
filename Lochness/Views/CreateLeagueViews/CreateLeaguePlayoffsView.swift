//
//  CreateLeaguePlayoffsView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct CreateLeaguePlayoffsView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var viewModel: CreateLeagueViewModel
    
    @Binding var path: [Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CreateLeagueHeader(path: $path)
            
            VStack(alignment: .leading, spacing: 24) {
                modeSelectorStack
                playoffSizeStack
            }
            Spacer()
            CreateLeagueNextButton(path: $path, last: true)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
    
    var playoffSizeStack: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Playoff Size \(viewModel.leagueSize.rawValue)")
                .font(.caption.bold())
            HStack {
                ForEach(PlayoffSize.allCases, id: \.rawValue) { size in
                    if size.displayValue < viewModel.leagueSize.rawValue {
                        SizeCircle(sizeOption: size, selectedSize: $viewModel.playoffSize)
                    }
                }
            }
        }
    }
    
    private var modeSelectorStack: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Playoff Mode")
                .font(.caption.bold())
            ModeBox(selectedMode: $viewModel.playoffMode, mode: .elimination)
            ModeBox(selectedMode: $viewModel.playoffMode, mode: .continuous)
        }
    }
}

#Preview {
    CreateLeaguePlayoffsView(path: .constant([0, 1]))
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.createLeagueViewModel)
}
