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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeViewModel)
        }
    }
}
