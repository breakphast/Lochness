//
//  Binding.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/10/24.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
    var dollarBinding: Binding<String> {
        Binding<String>(
            get: { "$" + self.wrappedValue },
            set: {
                if $0.first == "$" {
                    self.wrappedValue = String($0.dropFirst())
                } else {
                    self.wrappedValue = $0
                }
            }
        )
    }
}
