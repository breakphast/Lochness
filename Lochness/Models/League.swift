//
//  League.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/2/24.
//

import Foundation

class League: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isPrivate: Bool
    var users: [String]
    
    init(id: UUID = UUID(), name: String, isPrivate: Bool, users: [String]) {
        self.id = id
        self.name = name
        self.isPrivate = isPrivate
        self.users = users
    }
}
