//
//  UIApplication.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/15/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
