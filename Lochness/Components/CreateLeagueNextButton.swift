//
//  CreateLeagueNextButton.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct CreateLeagueNextButton: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var viewModel: CreateLeagueViewModel
    @Binding var path: [Int]
    
    var main: Bool = false
    var last: Bool = false
    
    var body: some View {
        Button {
            if main {
                viewModel.mainAppend()
            } else if last {
                if let user = homeViewModel.activeUser {
                    viewModel.createLeague(userID: user.id.uuidString)
                }
            } else {
                viewModel.childAppend()
            }
        } label: {
            Text(!last ? "NEXT" : "CREATE LEAGUE")
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 56, alignment: .center)
                .foregroundStyle(.white)
                .background(
                    .main700
                        .shadow(.drop(color: .main700.opacity(0.5), radius: 4)), in: .rect(cornerRadius: 8)
                )
        }
    }
}
