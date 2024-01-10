//
//  TabBarButton.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/8/24.
//

import SwiftUI

struct TabBarButton: View {
    let image: Image
    let title: String
    
    var body: some View {
        VStack(spacing: 6) {
            image
            Text(title)
                .font(.caption2.bold())
                .foregroundStyle(.main900)
        }
        .frame(width: 48, height: 32)
    }
}

#Preview {
    TabBarButton(image: Image(.home), title: "Home")
}
