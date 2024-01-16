//
//  DropdownPicker.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct DropdownPicker: View {
    var hint: String
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 180
    var cornerRadius: CGFloat = 8
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
                            UIApplication.shared.endEditing()
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
                        .shadow(.drop(color: .main700.opacity(0.5), radius: 4)), in: .rect(cornerRadius: cornerRadius)
                )
                .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
            }
            .frame(height: 56)
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
        .foregroundStyle(SportOptions(rawValue: selection) == nil ? .gray.opacity(0.75) : .main800)
    }
    
    var optionsView: some View {
        VStack {
            ForEach(SportOptions.allCases, id: \.self) { option in
                HStack {
                    Text(option.rawValue)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .opacity(selection == option.rawValue ? 1 : 0)
                }
                .foregroundStyle(selection == option.rawValue ? Color.primary : Color.gray)
                .animation(.none, value: selection)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option.rawValue
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
