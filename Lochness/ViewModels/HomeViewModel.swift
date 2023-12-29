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
    @Published var allUsers = [User]()
    
    var activeUser: User? = nil
    
    private let gameService = GameService()
    private let betService = BetService()
    private let scoreService = ScoreService()
    private let userService = UserService()

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        gameService.$allGames
            .combineLatest(gameService.$allBetOptions)
            .sink { [weak self] returnedGames, returnedBetOptions in
                self?.allGames = returnedGames
                self?.allBetOptions = returnedBetOptions
            }
            .store(in: &cancellables)
                
        betService.$allBets
            .sink { [weak self] returnedBets in
                self?.allBets = returnedBets
            }
            .store(in: &cancellables)
        
        scoreService.$allScores
            .combineLatest(betService.$allBets)
            .sink { [weak self] returnedScores, returnedBets in
                self?.allScores = returnedScores
                self?.allBets = returnedBets
            }
            .store(in: &cancellables)
        
        userService.$allUsers
            .sink { [weak self] returnedUsers in
                self?.allUsers = returnedUsers
                if let user = returnedUsers.first {
                    self?.activeUser = user
                    print("Active User:", user.username)
                }
            }
            .store(in: &cancellables)
    }
    
    func addBet(from betOption: BetOption) async throws {
        if let activeUser {
            try await betService.add(bet: betService.makeBet(from: betOption, user: activeUser))
        }
    }
    
    func deleteBet(_ bet: Bet) async throws {
        try await betService.delete(bet: bet)
    }
}
