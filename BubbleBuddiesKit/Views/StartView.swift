import SwiftUI

/// Main start screen of the game
struct StartView: View {
    @AppStorage("bestScore") private var bestScore: Int = 0
    @State private var showGame = false
    @State private var showSettings = false
    @State private var showAchievements = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Title
                    Text("Bubble Buddies")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primary)
                    // Best score
                    if bestScore > 0 {
                        Text("Best Score: \(bestScore)")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(16)
                    }
                    // Game logo or image
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                        .padding()
                    
                    // Buttons
                    VStack(spacing: 20) {
                        Button(action: { showGame = true }) {
                            MenuButton(title: "Play", systemImage: "play.fill")
                        }
                        
                        Button(action: { showSettings = true }) {
                            MenuButton(title: "Settings", systemImage: "gear")
                        }
                        
                        Button(action: { showAchievements = true }) {
                            MenuButton(title: "Achievements", systemImage: "trophy.fill")
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $showGame) {
                GameView()
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .navigationDestination(isPresented: $showAchievements) {
                AchievementsView()
            }
        }
    }
}

/// Custom button style for menu buttons
struct MenuButton: View {
    let title: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title2)
            Text(title)
                .font(.title2)
        }
        .foregroundColor(.white)
        .frame(width: 200, height: 50)
        .background(Color.blue)
        .cornerRadius(25)
        .shadow(radius: 5)
    }
}

#Preview {
    StartView()
} 