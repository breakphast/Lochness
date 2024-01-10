//
//  BetButton.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/8/24.
//

import SwiftUI

struct BetButton: View {
    @EnvironmentObject private var betViewModel: BetViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    var selected: Bool {
        return betViewModel.selectedBetOptions.contains(where: {$0.id.uuidString == betOptionID})
    }
    
    let betOptionID: String
    let line: String?
    let odds: String
    
    var body: some View {
        VStack {
            if let line {
                Text(line)
                    .foregroundStyle(selected ? .white : .main800)
            }
            Text(odds)
                .foregroundStyle(selected ? .white : .main700)
        }
        .frame(width: 72, height: 48)
        .font(.caption.bold())
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(selected ? .main500 : .clear)
                .stroke(selected ? .main800 : .main700, lineWidth: 2)
        )
        .onTapGesture {
            withAnimation(.bouncy) {
                if let betOption = homeViewModel.allBetOptions.first(where: {$0.id.uuidString == betOptionID}) {
                    betViewModel.selectBet(betOption)
                }
            }
        }
    }
}

#Preview {
    BetButton(betOptionID: "", line: "+7.5", odds: "+200")
        .environmentObject(Preview.dev.betViewModel)
}
