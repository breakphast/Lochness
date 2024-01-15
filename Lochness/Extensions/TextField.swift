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
            .padding(.leading, 16)
            .padding(.vertical, 10)
            .background(
                .white
                    .shadow(.drop(color: .main700.opacity(0.5), radius: 4)), in: .rect(cornerRadius: cornerRadius)
            )
    }
}
