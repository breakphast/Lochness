//
//  HomeViewModel.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var allGames = [Game]()
    @Published var allBetOptions = [BetOption]()
    @Published var allScores = [Score]()
    @Published var allBets = [Bet]()
    
    private let gameService = GameService()
    private let betService = BetService()
    private let scoreService = ScoreService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        gameService.$allGames
            .sink { [weak self] returnedGames in
                self?.allGames = returnedGames
            }
            .store(in: &cancellables)
        
        gameService.$allBetOptions
            .sink { [weak self] returnedBetOptions in
                self?.allBetOptions = returnedBetOptions
            }
            .store(in: &cancellables)
        
        betService.$allBets
            .sink { [weak self] returnedBets in
                self?.allBets = returnedBets
            }
            .store(in: &cancellables)
        
        scoreService.$allScores
            .sink { [weak self] returnedScores in
                self?.allScores = returnedScores
            }
            .store(in: &cancellables)
    }
    
    func addBet(from betOption: BetOption) async throws {
        try await betService.add(bet: betService.makeBet(from: betOption))
    }
}
