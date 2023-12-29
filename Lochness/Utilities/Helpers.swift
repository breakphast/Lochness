//
//  Helpers.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/28/23.
//

import Foundation
import SwiftUI

class Helpers {
    static var decoder = JSONDecoder()
    static var encoder = JSONEncoder()
    
    init() {
        Self.decoder.dateDecodingStrategy = .iso8601
    }
}
