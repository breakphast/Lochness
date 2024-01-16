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
            VStack(spacing: 16) {
                CreateLeagueHeader(path: $viewModel.path)
                
                VStack(spacing: 24) {
                    leagueNameTextField
                    leagueSizeStack
                    sportDropdown
                }
                Spacer()
                CreateLeagueNextButton(path: $viewModel.path, main: true)
                    .disabled(viewModel.leagueName.count < 4 || SportOptions(rawValue: viewModel.leagueSport) == nil)
                    .opacity(viewModel.leagueName.count < 4 || SportOptions(rawValue: viewModel.leagueSport) == nil ? 0.5 : 1)
            }
            .padding()
            .navigationDestination(for: Int.self) { value in
                switch value {
                case 0:
                    CreateLeagueModesView(path: $viewModel.path)
                case 1:
                    if viewModel.leagueMode == .classic {
                        CreateLeaguePlayoffsView(path: $viewModel.path)
                    } else {
                        CreateLeaguePayoutView(path: $viewModel.path)
                    }
                default:
                    CreateLeagueModesView(path: $viewModel.path)
                }
            }
        }
    }
    
    var sportDropdown: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sport")
                .font(.caption.bold())
            DropdownPicker(hint: "Sport", anchor: .bottom, selection: $viewModel.leagueSport, showOptions: $showOptions)
        }
    }
    
    var leagueNameTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("League Name")
                .font(.caption.bold())
            TextField("League name", text: $viewModel.leagueName)
                .textFieldStyle(Border(color: .main700, cornerRadius: 8, leadingPadding: 16, verticalPadding: 16, fontSize: .body))
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
                ForEach(LeagueSizeOptions.allCases, id: \.self) { size in
                    Spacer()
                    SizeCircle(sizeOption: size, selectedSize: $viewModel.leagueSize)
                    Spacer()
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
