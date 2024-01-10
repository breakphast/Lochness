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
                }
                .frame(width: size.width)
            }
        }
    }
    
    @ViewBuilder
    func betslipHeader(_ size: CGSize) -> some View {
        HStack {
            Text("Betslip")
                .font(.callout.bold())
            Circle()
                .stroke(.white, lineWidth: 4)
                .fill(.main500)
                .frame(width: 24)
                .overlay {
                    Text("\(betViewModel.selectedBetOptions.count)")
                        .font(.caption2)
                        .fontWeight(.heavy)
                }
        }
        .foregroundStyle(.white)
        .padding()
        .frame(width: size.width, alignment: .leading)
        .background(
            Color.main500
                .shadow(.drop(radius: 8))
        )
        .overlay {
            Rectangle()
                .frame(height: 2)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    @ViewBuilder
    func betCard(_ size: CGSize, betOption: BetOption) -> some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                Image(systemName: "xmark")
                    .fontDesign(.rounded)
                    .bold()
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center) {
                        Text(betOption.team)
                            .font(.caption.bold())
                        Spacer()
                        Text(betOption.formattedOdds)
                            .font(.caption.bold())
                    }
                    Text(betOption.betType.rawValue)
                        .font(.caption2)
                    Text(betOption.matchupTeamsDescription)
                        .font(.caption2.bold())
                }
            }
            .foregroundStyle(.white)
            HStack {
                VStack(alignment: .leading) {
                    Text("Wager")
                    Text("$80.00")
                }
                .font(.caption)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white)
                        .stroke(.main800, lineWidth: 2)
                )
                
                VStack(alignment: .leading) {
                    Text("Wager")
                    Text("$80.00")
                }
                .font(.caption)
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
}
