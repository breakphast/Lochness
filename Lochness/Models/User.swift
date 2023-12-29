//
//  User.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/29/23.
//

import Foundation

class User: Codable, Identifiable {
    var id = UUID()
    var username: String
    
    init(id: UUID = UUID(), username: String) {
        self.id = id
        self.username = username
    }
}
