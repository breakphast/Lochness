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
    let lineWidth: CGFloat
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}
