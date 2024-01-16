//
//  TextField.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/4/24.
//

import Foundation
import SwiftUI

struct Border: TextFieldStyle {
    let color: Color
    let cornerRadius: CGFloat
    let leadingPadding: CGFloat
    let verticalPadding: CGFloat
    let fontSize: Font
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(fontSize)
            .padding(.leading, leadingPadding)
            .padding(.vertical, verticalPadding)
            .background(
                .white
                    .shadow(.drop(color: color.opacity(0.5), radius: 4)), in: .rect(cornerRadius: cornerRadius)
            )
    }
}
