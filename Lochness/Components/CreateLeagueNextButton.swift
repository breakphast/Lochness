//
//  CreateLeagueNextButton.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct CreateLeagueNextButton: View {
    @EnvironmentObject private var viewModel: CreateLeagueViewModel
    @Binding var path: [Int]
    
    let main: Bool
    
    var body: some View {
        Text("Next")
            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
            .foregroundStyle(.white)
            .background(
                .main700
                    .shadow(.drop(color: .main700.opacity(0.5), radius: 4)), in: .rect(cornerRadius: 8)
            )
            .onTapGesture {
                if main {
                    viewModel.mainAppend()
                } else {
                    viewModel.childAppend()
                }
            }
    }
}
