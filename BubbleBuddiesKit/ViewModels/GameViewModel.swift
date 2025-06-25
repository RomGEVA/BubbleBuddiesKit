import SwiftUI

/// ViewModel responsible for managing the game state and logic
class GameViewModel: ObservableObject {
    /// Collection of active bubbles in the game
    @Published var bubbles: [Bubble] = []
    /// Current player's score
    @Published var score: Int = 0
    
    /// Size of the game grid (5x5)
    private let gridSize = 5
    /// Size of each bubble in points
    private let bubbleSize: CGFloat = 60
    /// Space between bubbles in points
    private let spacing: CGFloat = 10
    
    init() {
        generateBubbles()
    }
    
    /// Generates a new grid of bubbles
    func generateBubbles() {
        bubbles = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                var bubble = Bubble.random()
                bubble.position = CGPoint(
                    x: CGFloat(col) * (bubbleSize + spacing) + bubbleSize/2,
                    y: CGFloat(row) * (bubbleSize + spacing) + bubbleSize/2
                )
                bubbles.append(bubble)
            }
        }
    }
    
    /// Handles bubble popping when tapped
    /// - Parameter position: The tap position on screen
    func popBubble(at position: CGPoint) {
        guard let index = bubbles.firstIndex(where: { bubble in
            let distance = sqrt(
                pow(bubble.position.x - position.x, 2) +
                pow(bubble.position.y - position.y, 2)
            )
            return distance <= bubbleSize/2
        }) else { return }
        
        withAnimation(.easeOut(duration: 0.3)) {
            bubbles.remove(at: index)
            score += 1
        }
        
        if bubbles.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.generateBubbles()
            }
        }
    }
} 