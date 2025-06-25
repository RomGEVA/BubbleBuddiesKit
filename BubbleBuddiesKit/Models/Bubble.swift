import SwiftUI

/// A model representing a bubble in the game
struct Bubble: Identifiable {
    /// Unique identifier for the bubble
    let id = UUID()
    /// Animal emoji displayed inside the bubble
    let emoji: String
    /// Color of the bubble
    let color: Color
    /// Current position of the bubble on screen
    var position: CGPoint
    
    /// Collection of possible animal emojis for bubbles
    static let possibleEmojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
    /// Collection of possible colors for bubbles
    static let possibleColors: [Color] = [.blue, .green, .orange, .purple, .pink, .red]
    
    /// Creates a random bubble with random emoji and color
    static func random() -> Bubble {
        Bubble(
            emoji: possibleEmojis.randomElement() ?? "🐶",
            color: possibleColors.randomElement() ?? .blue,
            position: .zero
        )
    }
} 