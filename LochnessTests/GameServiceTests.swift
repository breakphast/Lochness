//
//  GameServiceTests.swift
//  LochnessTests
//
//  Created by Desmond Fitch on 12/28/23.
//

import XCTest
import Combine
@testable import Lochness

final class GameServiceTests: XCTestCase {
    var gameService: MockGameService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        gameService = MockGameService()
    }

    override func tearDownWithError() throws {
        gameService = nil
        try super.tearDownWithError()
    }
    
    func testGetGamesLocally() {
        gameService.getGamesLocally()
        
        XCTAssertNotNil(gameService.allGames, "Failed to get games from local JSON.")
    }
}

class MockGameService {
    @Published var allGames = [Game]()
    @Published var allBetOptions = [BetOption]()
    
    private var gameSubscription: AnyCancellable?
    
    private var decoder = JSONDecoder()
    private var encoder = JSONEncoder()
    
    init() {
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func loadLocalNFLData() -> AnyPublisher<Data, Error> {
        guard let url = Bundle.main.url(forResource: "nflOddsData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to locate nflOddsData.json"]))
                .eraseToAnyPublisher()
        }
        
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getGamesLocally() {
        gameSubscription = loadLocalNFLData()
            .decode(type: [GameElement].self, decoder: decoder)
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
    
    func generateBetOptions(game: Game) -> [BetOption] {
        return BetType.allCases.flatMap { type -> [BetOption] in
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
    }
}

protocol GameServiceProtocol {
    var allGames: [Game] { get }
    var allBetOptions: [BetOption] { get }

    func add(game: Game) async throws
    func delete(game: Game)
    func updateScore(game: Game, score: ScoreElement)
    func getGamesFromFirestore()
    func loadnflData() async throws -> Data
    func getGames()
    func generateBetOptions(game: Game) -> [BetOption]
}

extension GameServiceProtocol {
    func add(game: Game) async throws {
        // Default empty implementation
    }
    
    func delete(game: Game) {
        // Default empty implementation
    }
    
    func updateScore(game: Game, score: ScoreElement) {
        // Default empty implementation
    }
    
    func getGamesFromFirestore() {
        // Default empty implementation
    }
    
    func loadnflData() async throws -> Data {
        return Data()
    }
    
    func getGames() {
        // Default empty implementation
    }
    
    func generateBetOptions(game: Game) -> [BetOption] {
        return []
    }
}
