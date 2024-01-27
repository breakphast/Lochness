//
//  ScoreService.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/27/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class ScoreService {
    @Published var allScores = [Score]()
    
    private var scoreSubscription: AnyCancellable?
    private var scoresListener: ListenerRegistration?
    private var scoreReference: CollectionReference?
    
    private var decoder = JSONDecoder()
    private var encoder = JSONEncoder()
    private var db = Firestore.firestore()
    
    init() {
        decoder.dateDecodingStrategy = .iso8601
        self.scoreReference = db.collection("scores")
        
        getScoresFromFirestore()
    }
    
    // MARK: Firebase Functions
    func add(score: Score) async throws {
        if let scoreReference {
            try await FirebaseManager.add(item: score, id: score.id, to: scoreReference)
        }
    }
    
    private func getScoresFromFirestore() {
        if let scoreReference {
            self.scoresListener = FirebaseManager.fetch(query: scoreReference, convert: parseScoreFromDocument(_:)) { [weak self] scores in
                self?.allScores = scores
            }
        }
    }
    
    private func parseScoreFromDocument(_ document: QueryDocumentSnapshot) -> Score {
        let data = document.data()
        
        let scoreElement = ScoreElement(
            id: data["id"] as? String ?? "",
            sportKey: data["sport_key"] as? String ?? "",
            sportTitle: data["sport_title"] as? String ?? "",
            commenceTime: Date(timeIntervalSince1970: TimeInterval(data["commence_time"] as? Int ?? 0)),
            completed: data["completed"] as? Bool ?? false,
            homeTeam: data["home_team"] as? String ?? "",
            awayTeam: data["away_team"] as? String ?? "",
            scores: nil,
            lastUpdate: data["last_update"] as? String
        )
        
        let score = Score(scoreElement: scoreElement)
        score.homeScore = data["homeScore"] as? String ?? ""
        score.awayScore = data["awayScore"] as? String ?? ""
        
        return score
    }
    
    // MARK: Network/Data Functions
    private func getScoresLocally() {
        scoreSubscription = loadLocalNFLScoresData()
            .decode(type: [ScoreElement].self, decoder: decoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedScores in
                guard let self = self else { return }
                
                let scores = returnedScores.map { Score(scoreElement: $0) }
                self.allScores = scores
                
//                Task {
//                    for score in scores {
//                        do {
//                            try await self.add(score: score)
//                        } catch {
//                            print("Error adding score: \(error.localizedDescription)")
//                        }
//                    }
//                }
            })
    }
    
    private func getScores() {
        guard let url = URL(string: "https://api.the-odds-api.com/v4/sports/americanfootball_nfl/scores/?daysFrom=3&apiKey=4361370f2df59d9c4aabf5b7ff5fd438") else {
            return
        }
        
        scoreSubscription = NetworkingManager.download(url: url)
            .decode(type: [ScoreElement].self, decoder: decoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedScores in
                guard let self = self else { return }

                let scores = returnedScores.map { Score(scoreElement: $0) }
                self.allScores = scores
                
//                Task {
//                    for score in scores {
//                        do {
//                            try await self.add(score: score)
//                        } catch {
//                            print("Error adding score: \(error.localizedDescription)")
//                        }
//                    }
//                }
            })
    }
    
    private func loadLocalNFLScoresData() -> AnyPublisher<Data, Error> {
        guard let url = Bundle.main.url(forResource: "nflScoresData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate nflOddsData.json"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
