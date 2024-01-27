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
    @Published var allUsers = [User]()
    @Published var allLeagues = [League]()
    @Published var allContests = [Contest]()
    
    @Published var isLoading = true
    
    @Published var activeUser: User? = nil
    @Published var activeLeague: League? = nil
    
    private let gameService = GameService()
    private let betService = BetService()
    private let scoreService = ScoreService()
    private let userService = UserService()
    private let leagueService = LeagueService()
    private let contestService = ContestService()

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.bouncy) {
                self.isLoading = false
            }
        }
    }
    
    func addSubscribers() {
        gameService.$allGames
            .combineLatest(gameService.$allBetOptions)
            .sink { [weak self] returnedGames, returnedBetOptions in
                self?.allGames = returnedGames
                self?.allBetOptions = returnedBetOptions
            }
            .store(in: &cancellables)
        
        userService.$allUsers
            .sink { [weak self] returnedUsers in
                self?.allUsers = returnedUsers
                if let user = returnedUsers.first {
                    self?.activeUser = user
                    print("Active User:", user.username + " \(user.id.uuidString)")
                }
            }
            .store(in: &cancellables)
        
        leagueService.$allLeagues
            .sink { [weak self] returnedLeagues in
                guard let self = self else { return }
                if let user = activeUser {
                    let userLeagues = returnedLeagues.map { $0.users.contains(user.id.uuidString)}
                    self.allLeagues = returnedLeagues
                }
//                if let league = returnedLeagues.first {
//                    self.activeLeague = league
//                    print("Active League:", league.id.uuidString)
//                }
            }
            .store(in: &cancellables)
    }
    
    func addLeague(_ league: League) async throws {
        if activeUser != nil {
            try await leagueService.add(league: league)
        }
    }
    
    func addUserToLeague(league: League) async throws {
        if let activeUser {
            try await leagueService.addUserToLeague(user: activeUser, league: league)
        }
    }
    
    func updateUserPoints(contest: Contest, points: Double) async throws {
        if let activeUser {
            try await contestService.updateUserPoints(contestID: contest.id.uuidString, userID: activeUser.id.uuidString, points: points)
        }
    }
    
    func payoutForUser(rank: Int, payouts: [Double]) -> Double {
        if rank > 0 && rank <= payouts.count {
            return payouts[rank - 1]
        } else {
            return 0.0
        }
    }
    
    func addContest() async throws {
        if let activeUser {
            let contest = contestService.makeContest(title: "Smipher", entryFee: 10.0)
            contest.enteredUsers = [activeUser.id.uuidString]
            try await contestService.add(contest: contest)
            
        }
    }
    
    func deleteBet(_ bet: Bet) async throws {
        try await betService.delete(bet: bet)
    }
}
