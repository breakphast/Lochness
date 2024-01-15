//
//  Main.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct CreateLeagueMainView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var viewModel: CreateLeagueViewModel
    
    @State private var showOptions = false
    
    @Namespace private var animation

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: 24) {
                CreateLeagueHeader(path: $viewModel.path)
                
                leagueNameTextField
                leagueSizeStack
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sport")
                        .font(.caption)
                    DropdownPicker(hint: "Sport", anchor: .bottom, selection: $viewModel.leagueSport, showOptions: $showOptions)
                }
                Spacer()
                CreateLeagueNextButton(path: $viewModel.path, main: true)
            }
            .padding()
            .navigationDestination(for: Int.self) { value in
                switch value {
                case 0:
                    CreateLeagueModesView(path: $viewModel.path)
                case 1:
                    Text("ello govnah")
                default:
                    CreateLeagueModesView(path: $viewModel.path)
                }
            }
        }
    }
    
    var leagueNameTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("League Name")
                .font(.caption)
            TextField("League name", text: $viewModel.leagueName)
                .textFieldStyle(Border(color: .main500, cornerRadius: 8, lineWidth: 2))
                .autocorrectionDisabled()
        }
    }
    
    @ViewBuilder
    var leagueSizeStack: some View {
        VStack(spacing: 16) {
            Text("League Size")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Spacer()
                ForEach(LeagueSizeOptions.allCases, id: \.self) { size in
                    LeagueSizeCircle(size: size.rawValue, selectedLeagueSize: $viewModel.leagueSize)
                }
            }
        }
    }
}

#Preview {
    CreateLeagueMainView()
        .environmentObject(Preview.dev.homeViewModel)
        .environmentObject(Preview.dev.createLeagueViewModel)
}
