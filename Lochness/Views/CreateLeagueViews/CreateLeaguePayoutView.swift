//
//  CreateLeaguePayoutView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct CreateLeaguePayoutView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var viewModel: CreateLeagueViewModel
    
    @State private var entryFee = ""
    @State private var free = false
    
    @Binding var path: [Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            CreateLeagueHeader(path: $path)
            
            VStack(alignment: .leading, spacing: 24) {
                modeSelectorStack
                entryFeeBox
            }
            Spacer()
            CreateLeagueNextButton(path: $path, last: true)
                .disabled(entryFee.isEmpty)
                .opacity(entryFee.isEmpty ? 0.5 : 1)
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
    
    private var entryFeeBox: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Entry Fee")
                .font(.caption.bold())
            TextField("$0.00", text: $entryFee.dollarBinding)
                .frame(width: 80)
                .textFieldStyle(Border(color: .main700, cornerRadius: 8, leadingPadding: 12, verticalPadding: 10, fontSize: .body.bold()))
                .keyboardType(.numberPad)
                .keyboardShortcut(.return)
        }
    }
    
    private var modeSelectorStack: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payout Mode")
                .font(.caption.bold())
            ModeBox(selectedMode: $viewModel.payoutStructure, mode: .topHeavy)
            ModeBox(selectedMode: $viewModel.payoutStructure, mode: .balanced)
        }
    }
}

#Preview {
    CreateLeaguePayoutView(path: .constant([0, 1]))
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.createLeagueViewModel)
}
