//
//  LochnessApp.swift
//  Lochness
//
//  Created by Desmond Fitch on 12/23/23.
//

import SwiftUI
import Firebase

@main
struct LochnessApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var betViewModel = BetViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(homeViewModel)
                .environmentObject(betViewModel)
        }
    }
}
