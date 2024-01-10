//
//  CreateLeagueView.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/3/24.
//

import SwiftUI

struct CreateLeagueView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @State private var name: String = ""
    @State private var size: Int = 4
    @State private var sport = "Select Sport"
    @State private var wagerMode: WagerMode? = nil
    @State private var playoffMode: PlayoffMode? = nil
    @State private var showOptions = false
    
    @State private var showNext = false
    
    let leagueSizeOptions = [4, 6, 8, 10, 12, 14]
    let sportOptions = ["NFL", "NBA", "NHL", "MLB"]
    let wagerOptions = [WagerMode.fixed, WagerMode.bankroll]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
//                leagueNameTextField
//                DropdownPicker(hint: "Sport", options: sportOptions, anchor: .bottom, selection: $sport, showOptions: $showOptions)
//                leagueSizeStack
                wagerModeStack
                playoffModeStack
                Spacer()
                nextButton
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .fontDesign(.rounded)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("Create League")
                        .font(.title2.bold())
                        .fontDesign(.rounded)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    var leagueNameTextField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("League Name")
                .font(.caption)
            TextField("League name", text: $name)
                .textFieldStyle(Border(color: .primary, cornerRadius: 16, lineWidth: 1))
                .autocorrectionDisabled()
        }
    }
    
    var leagueSizeStack: some View {
        VStack(spacing: 16) {
            Text("League Size")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Spacer()
                ForEach(leagueSizeOptions, id: \.self) { size in
                    LeagueSizeCircle(size: size, selectedLeagueSize: $size)
                }
            }
        }
    }
    
    var wagerModeStack: some View {
        VStack(alignment: .leading) {
            Text("Wager Mode")
                .font(.caption)
            WagerModeBox(wagerMode: $wagerMode, mode: .fixed, secondaryText: "Receive a fixed number of games to bet each week")
            WagerModeBox(wagerMode: $wagerMode, mode: .bankroll, secondaryText: "Receive a bankroll to spend freely each week")
        }
    }
    
    var playoffModeStack: some View {
        VStack(alignment: .leading) {
            Text("Playoff Mode")
                .font(.caption)
            PlayoffModeBox(playoffMode: $playoffMode, mode: .elimination, secondaryText: "Lowest scoring players are eliminated each week")
            PlayoffModeBox(playoffMode: $playoffMode, mode: .continuous, secondaryText: "Points are tallied over several weeks")
        }
    }
    
    var nextButton: some View {
        Text("Next")
            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue)
            )
            .onTapGesture {
                if let user = homeViewModel.activeUser, let wagerMode {
                    let league = League(name: name, users: [user.id.uuidString], size: size, sport: sport, wagerMode: wagerMode.rawValue, playoffMode: PlayoffMode.elimination.rawValue, playoffSize: 8)
                    Task {
                        try await homeViewModel.addLeague(league)
                    }
                }
            }
    }
}

struct LeagueSizeCircle: View {
    let size: Int
    @Binding var selectedLeagueSize: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(selectedLeagueSize == size ? .black : .red)
                .stroke((selectedLeagueSize == size ? .red : .black), lineWidth: (selectedLeagueSize == size ? 2: 1))
                .frame(width: 44)
            Text(String(size))
                .font(.caption.bold())
                .foregroundStyle(selectedLeagueSize == size ? .red : .black)
        }
        .onTapGesture {
            withAnimation(.spring) {
                selectedLeagueSize = size
            }
        }
        Spacer()
    }
}

struct WagerModeBox: View {
    @State private var selected = false
    @Binding var wagerMode: WagerMode?
    
    let mode: WagerMode
    let secondaryText: String
    
    var body: some View {
        HStack {
            Image(systemName: selected ? "circle.fill" : "circle")
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(mode.rawValue.capitalized)
                    .font(.subheadline)
                    .bold()
                Text(secondaryText)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.opacity(0.5))
        )
        .onTapGesture {
            selected.toggle()
            wagerMode = mode
        }
    }
}

struct PlayoffModeBox: View {
    @State private var selected = false
    @Binding var playoffMode: PlayoffMode?
    
    let mode: PlayoffMode
    let secondaryText: String
    
    var body: some View {
        HStack {
            Image(systemName: selected ? "circle.fill" : "circle")
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(mode.rawValue.capitalized)
                    .font(.subheadline)
                    .bold()
                Text(secondaryText)
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.opacity(0.5))
        )
        .onTapGesture {
            selected.toggle()
            playoffMode = mode
        }
    }
}

#Preview {
    CreateLeagueView()
}

struct DropdownPicker: View {
    var hint: String
    var options: [String]
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 180
    var cornerRadius: CGFloat = 16
    @Binding var selection: String
    @Binding var showOptions: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader {
                let size = $0.size
                
                VStack {
                    if showOptions && anchor == .top {
                        optionsView
                    }
                    initialState
                    .padding(.horizontal, 16)
                    .frame(width: size.width, height: size.height)
                    .background(.white)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation {
                            showOptions.toggle()
                        }
                    }
                    .zIndex(10)
                    
                    if showOptions && anchor == .bottom {
                        optionsView
                    }
                }
                .clipped()
                .background(
                    .white
                        .shadow(.drop(color: .primary.opacity(0.15), radius: 4)), in: .rect(cornerRadius: cornerRadius)
                )
                .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
            }
            .frame(height: 50)
        }
    }
    
    var initialState: some View {
        HStack {
            Text(selection)
                .lineLimit(1)
            
            Spacer(minLength: 0)
            
            Image(systemName: "chevron.down")
                .font(.title3)
                .rotationEffect(.degrees(showOptions ? -180 : 0))
        }
        .foregroundStyle(options.contains(selection) ? Color.primary : Color.gray)
    }
    
    var optionsView: some View {
        VStack {
            ForEach(options, id: \.self) { option in
                HStack {
                    Text(option)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .opacity(selection == option ? 1 : 0)
                }
                .foregroundStyle(selection == option ? Color.primary : Color.gray)
                .animation(.none, value: selection)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        showOptions = false
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .transition(.move(edge: anchor == .bottom ? .top : .bottom))
    }
    
    enum Anchor {
        case top
        case bottom
    }
}
