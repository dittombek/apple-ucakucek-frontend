//
//  ContentView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("userId") private var userId = 0

    var body: some View {
        if userId > 0 {
            MainTabView()
        } else if hasSeenOnboarding {
            SetupView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
