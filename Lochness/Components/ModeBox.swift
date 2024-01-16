//
//  ModeBox.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/16/24.
//

import SwiftUI

struct ModeBox<Mode: ModeRepresentable>: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var viewModel: CreateLeagueViewModel
    
    @Binding var selectedMode: Mode
    let mode: Mode
    
    var body: some View {
        HStack {
            Image(selectedMode.title == mode.title ? .radioSelected : .radio)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(mode.title)
                    .font(.subheadline)
                    .bold()
                Text(mode.secondaryText)
                    .font(.caption)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.main900)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(selectedMode.title == mode.title ? .main100 : .white)
                .stroke(.main700, lineWidth: 2)
        )
        .onTapGesture {
            withAnimation {
                selectedMode = mode
            }
        }
    }
}
