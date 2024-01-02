//
//  ContestService.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/2/24.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class ContestService {
    @Published var allContests = [Contest]()
    
    private var contestSubscription: AnyCancellable?
    private var contestListener: ListenerRegistration?
    private var contestsReference: CollectionReference?
    
    private var db = Firestore.firestore()

    init() {
        self.contestsReference = db.collection("contests")
        self.getContestsFromFirestore()
    }
    
    func makeContest(title: String, entryFee: Double) -> Contest {
        return Contest(title: title, entryFee: entryFee)
    }
    
    func add(contest: Contest) async throws {
        if let contestsReference {
            try await FirebaseManager.add(item: contest, id: contest.id.uuidString, to: contestsReference)
        }
    }
    
    private func getContestsFromFirestore() {
        if let contestsReference {
            self.contestListener = FirebaseManager.fetch(query: contestsReference, convert: parseContestFromDocument(_:)) { [weak self] contests in
                self?.allContests = contests
            }
        }
    }
    
    func updateUserPoints(contestID: String, userID: String, points: Double) async throws {
        guard let contestsReference = self.contestsReference else {
            print("No reference to contests collection")
            return
        }

        let contestDocument = contestsReference.document(contestID)
        let fieldPath = "points.\(userID)"
        
        do {
            try await contestDocument.updateData([fieldPath: points])
            print("Contest points successfully updated")
        } catch {
            print("Error updating contest points: \(error)")
            throw error
        }
    }
    
    private func parseContestFromDocument(_ document: QueryDocumentSnapshot) -> Contest {
        let data = document.data()

        let id = data["id"] as? String ?? ""
        let title = data["title"] as? String ?? ""
        let entryFee = data["entryFee"] as? Double ?? 0.0
        let entryLimit = data["entryLimit"] as? Int ?? 10
        let entryCount = data["entryCount"] as? Int ?? 0
        let enteredUsers = data["enteredUsers"] as? [String] ?? []
        let completed = data["completed"] as? Bool ?? false
        let points = data["points"] as? [String: Double] ?? [:]

        let payouts = [
            (Double(entryLimit) * entryFee) * 0.7,
            (Double(entryLimit) * entryFee) * 0.2,
            (Double(entryLimit) * entryFee) * 0.05
        ]

        let contest = Contest(id: UUID(uuidString: id) ?? UUID(), title: title, entryFee: entryFee)
        contest.entryLimit = entryLimit
        contest.entryCount = entryCount
        contest.enteredUsers = enteredUsers
        contest.completed = completed
        contest.points = points
        contest.payouts = payouts

        return contest
    }
}
