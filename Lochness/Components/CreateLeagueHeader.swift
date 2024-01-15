//
//  CreateLeagueHeader.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import SwiftUI

struct CreateLeagueHeader: View {
    @Binding var path: [Int]
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .onTapGesture {
                    path.removeLast()
                }
            Text("Create League")
                .font(.title2)
            Spacer()
        }
        .fontWeight(.bold)
        .fontDesign(.rounded)
        .foregroundStyle(.main900)
        .padding(.bottom, 24)
    }
}
