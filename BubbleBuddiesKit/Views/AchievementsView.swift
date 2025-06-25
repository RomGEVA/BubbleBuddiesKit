import SwiftUI

/// Achievements screen of the game
struct AchievementsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let achievements = [
        Achievement(title: "First Pop", description: "Pop your first bubble", isUnlocked: true),
        Achievement(title: "Bubble Master", description: "Pop 100 bubbles", isUnlocked: false),
        Achievement(title: "Speed Demon", description: "Clear a level in under 30 seconds", isUnlocked: false),
        Achievement(title: "Perfect Score", description: "Complete a level without missing any bubbles", isUnlocked: false)
    ]
    
    var body: some View {
        NavigationStack {
            List(achievements) { achievement in
                HStack {
                    Image(systemName: achievement.isUnlocked ? "trophy.fill" : "trophy")
                        .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                    
                    VStack(alignment: .leading) {
                        Text(achievement.title)
                            .font(.headline)
                        Text(achievement.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// Model for game achievements
struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let isUnlocked: Bool
}

#Preview {
    AchievementsView()
} 