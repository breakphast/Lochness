//
//  LeagueSizeCircle.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct LeagueSizeCircle: View {
    let size: Int
    @Binding var selectedLeagueSize: Int
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            Circle()
                .fill(selectedLeagueSize == size ? .main100 : .white)
                .stroke(.main700, lineWidth: (selectedLeagueSize == size ? 4: 2))
                .frame(width: 44)
            Text(String(size))
                .font(.caption)
                .fontWeight(.heavy)
                .foregroundStyle(.main700)
        }
        .onTapGesture {
            withAnimation(.bouncy) {
                selectedLeagueSize = size
            }
        }
        Spacer()
    }
}
