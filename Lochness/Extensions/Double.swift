//
//  Double.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/24/23.
//

import Foundation

extension Double {
    var twoDecimalString: String {
        return String(format: "%.2f", self)
    }
    var oneDecimalString: String {
        return String(format: "%.1f", self)
    }
    var noDecimalString: String {
        return String(format: "%.0f", self)
    }
}
