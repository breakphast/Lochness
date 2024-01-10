//
//  BetViewModel.swift
//  Lochness
//
//  Created by Desmond Fitch on 1/8/24.
//

import Foundation
import SwiftUI
import Combine

class BetViewModel: ObservableObject {
    @Published var allBets = [Bet]()
    @Published var allScores = [Score]()
    @Published var selectedBetOptions = [BetOption]()
    
    var betslipActive = false
    
    private let betService = BetService()
    private let scoreService = ScoreService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
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
        
        $selectedBetOptions
            .sink { [weak self] returnedBets in
                if !returnedBets.isEmpty {
                    self?.betslipActive = true
                } else {
                    self?.betslipActive = false
                }
            }
            .store(in: &cancellables)
    }
    
    func addBet(from betOption: BetOption, for user: User, to league: League) async throws {
        let bet = betService.makeBet(from: betOption, user: user, league: league.id.uuidString, contest: league.id.uuidString)
        try await betService.add(bet: bet)
    }
    
    func selectBet(_ betOption: BetOption) {
        if self.selectedBetOptions.contains(where: {$0.id == betOption.id}) {
            self.selectedBetOptions.removeAll(where: { $0.id == betOption.id})
        } else {
            self.selectedBetOptions.append(betOption)
        }
    }
}
