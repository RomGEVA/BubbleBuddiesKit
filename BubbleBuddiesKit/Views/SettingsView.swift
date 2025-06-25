import SwiftUI
import StoreKit

/// Settings screen of the game
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("vibrationEnabled") private var vibrationEnabled = true
    @AppStorage("bestScore") private var bestScore: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Game Settings") {
                    Toggle("Sound Effects", isOn: $soundEnabled)
                    Toggle("Vibration", isOn: $vibrationEnabled)
                }
                
                Section("App") {
                    Button("Rate App") {
                        SKStoreReviewController.requestReview()
                    }
                    Button("Privacy Policy") {
                        if let url = URL(string: "https://www.termsfeed.com/live/5d91fa7e-e34e-477f-835f-79338a9cbe97") {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Reset Best Score", role: .destructive) {
                        bestScore = 0
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
} 
