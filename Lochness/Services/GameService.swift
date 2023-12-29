//
//  GameService.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class GameService {
    @Published var allGames = [Game]()
    @Published var allBetOptions = [BetOption]()
    
    private var gameSubscription: AnyCancellable?
    private var gamesListener: ListenerRegistration?
    private var gameReference: CollectionReference?
    
    private var db = Firestore.firestore()
    
    init() {
        self.gameReference = db.collection("games")
        getGamesFromFirestore()
    }
    
    // MARK: Firebase Functions
    private func add(game: Game) async throws {
        guard let gameReference else { return }
        
        let documentRef = gameReference.document(game.id)
        
        do {
            let data = try Helpers.encoder.encode(game)
            if let gameDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                try await documentRef.setData(gameDictionary)
                print("Game added successfully")
            }
        } catch {
            print("Error encoding game: \(error.localizedDescription)")
        }
    }
    
    private func delete(game: Game) {
        
    }
    
    private func updateScore(game: Game, score: ScoreElement) {
        
    }
    
    private func getGamesFromFirestore() {
        if let gameReference {
            self.gamesListener = FirebaseManager.fetch(query: gameReference, convert: parseGameFromDocument(_:)) { [weak self] games in
                self?.allGames = games.sorted(by: { $0.date < $1.date })
                self?.allBetOptions = games.flatMap { self?.generateBetOptions(game: $0) ?? [] }
                print("Game listener triggered.")
            }
        }
    }
    
    private func parseGameFromDocument(_ document: QueryDocumentSnapshot) -> Game {
        let data = document.data()
        
        let gameElement = GameElement(
            id: data["id"] as? String ?? "",
            sportKey: .americanfootball_nfl,
            sportTitle: .NFL,
            commenceTime: Date(timeIntervalSince1970: TimeInterval(data["date"] as? Int ?? 0)),
            completed: data["completed"] as? Bool ?? false,
            homeTeam: data["homeTeam"] as? String ?? "",
            awayTeam: data["awayTeam"] as? String ?? "",
            bookmakers: nil
        )
        
        let game = Game(gameElement: gameElement)

        game.homeMoneyLineOdds = data["homeMoneyLineOdds"] as? Int ?? 0
        game.awayMoneyLineOdds = data["awayMoneyLineOdds"] as? Int ?? 0
        game.homeSpreadLine = data["homeSpreadLine"] as? Double ?? 0.0
        game.homeSpreadOdds = data["homeSpreadOdds"] as? Double ?? 0.0
        game.awaySpreadLine = data["awaySpreadLine"] as? Double ?? 0.0
        game.awaySpreadOdds = data["awaySpreadOdds"] as? Double ?? 0.0
        game.overLine = data["overLine"] as? Double ?? 0.0
        game.overOdds = data["overOdds"] as? Double ?? 0.0
        game.underLine = data["underLine"] as? Double ?? 0.0
        game.underOdds = data["underOdds"] as? Double ?? 0.0
        
        return game
    }

    // MARK: Network/Data Functions
    func loadnflData() async throws -> Data {
        guard let url = Bundle.main.url(forResource: "nflOddsData", withExtension: "json") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate nflOddsData.json"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return data
    }
    
    private func loadLocalNFLData() -> AnyPublisher<Data, Error> {
        guard let url = Bundle.main.url(forResource: "nflOddsData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate nflOddsData.json"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func getGamesLocally() {
        gameSubscription = loadLocalNFLData()
            .decode(type: [GameElement].self, decoder: Helpers.decoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGames in
                guard let self = self else { return }
                
                let games = returnedGames.map { Game(gameElement: $0) }
                self.allGames = games
                self.allBetOptions = games.flatMap { self.generateBetOptions(game: $0) }
                
//                Task {
//                    for game in games {
//                        do {
//                            try await self.add(game: game)
//                        } catch {
//                            print("Error adding game: \(error.localizedDescription)")
//                        }
//                    }
//                }
            })
    }
    
    private func getGames() {
        guard let url = URL(string: "https://api.the-odds-api.com/v4/sports/americanfootball_nfl/odds/?apiKey=4361370f2df59d9c4aabf5b7ff5fd438&regions=us&markets=h2h,spreads,totals&oddsFormat=american&bookmakers=fanduel") else {
            return
        }
        
        gameSubscription = NetworkingManager.download(url: url)
            .decode(type: [GameElement].self, decoder: Helpers.decoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGames in
                let games = returnedGames.map { Game(gameElement: $0) }
                self?.allGames = games
                self?.allBetOptions = games.flatMap { self?.generateBetOptions(game: $0) ?? [] }
            })
    }
        
    private func generateBetOptions(game: Game) -> [BetOption] {
        let options = BetType.allCases.flatMap { type -> [BetOption] in
            switch type {
            case .spread:
                return [
                    BetOption(game: game, betType: type, odds: Int(game.awaySpreadOdds), line: Double(game.awaySpreadLine), selectedTeam: game.awayTeam),
                    BetOption(game: game, betType: type, odds: Int(game.homeSpreadOdds), line: Double(game.homeSpreadLine), selectedTeam: game.homeTeam)
                ]
            case .moneyline:
                return [
                    BetOption(game: game, betType: type, odds: Int(game.awayMoneyLineOdds), selectedTeam: game.awayTeam),
                    BetOption(game: game, betType: type, odds: Int(game.homeMoneyLineOdds), selectedTeam: game.homeTeam)
                ]
            case .over, .under:
                let odds = type == .over ? Int(game.overOdds) : Int(game.underOdds)
                let line = type == .over ? Double(game.overLine) : Double(game.underLine)
                return [BetOption(game: game, betType: type, odds: odds, line: line, selectedTeam: "\(game.awayTeam) @ \(game.homeTeam)")]
            }
        }
        
        if options.count >= 6 {
            let reorderedOptions = [
                options[0],
                options[2],
                options[4],
                options[1],
                options[3],
                options[5]
            ]
            return reorderedOptions
        } else {
            return options
        }
    }

}
