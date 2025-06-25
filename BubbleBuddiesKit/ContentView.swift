//
//  ContentView.swift
//  BubbleBuddiesKit
//
//  Created by Роман Главацкий on 25.06.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool?
    var body: some View {
        if hasSeenOnboarding ?? false {
            StartView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
