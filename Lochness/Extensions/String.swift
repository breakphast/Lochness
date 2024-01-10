//
//  String.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/8/24.
//

import Foundation
import SwiftUI

extension String {
    func substring(after prefix: String) -> String {
        guard let range = self.range(of: prefix) else { return self }
        return String(self[range.upperBound...])
    }
    
    var teamNameSplit: [Substring] {
        return self.split(separator: " ")
    }
}
