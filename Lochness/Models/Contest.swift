//
//  Contest.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/2/24.
//

import Foundation

class Contest: Identifiable, Codable {
    var id = UUID()
    var title: String
    let entryFee: Double
    var payouts: [Double]
    var entryLimit: Int
    var entryCount: Int
    var enteredUsers: [String]
    var completed: Bool
    var points: [String: Double]
    
    init(id: UUID = UUID(), title: String, entryFee: Double) {
        self.id = id
        self.title = title
        self.entryFee = entryFee
        self.entryLimit = 10
        self.entryCount = 0
        self.enteredUsers = [String]()
        self.completed = false
        self.points = [String: Double]()
        
        self.payouts = [
            (Double(entryLimit) * entryFee) * 0.7,
            (Double(entryLimit) * entryFee) * 0.2,
            (Double(entryLimit) * entryFee) * 0.05
        ]
    }
}
