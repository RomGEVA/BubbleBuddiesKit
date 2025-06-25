import SwiftUI
import SpriteKit

/// Main game view that displays the bubble grid and score
struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("bestScore") private var bestScore: Int = 0
    @State private var score: Int = 0
    private let scene: GameScene

    init() {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .resizeFill
        self.scene = scene
    }

    var body: some View {
        ZStack {
            // Красивый градиентный фон
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            SpriteView(scene: scene)
                .ignoresSafeArea()
                .background(Color.clear)

            VStack {
                HStack(spacing: 12) {
                    
                    Button(action: { finishGame() }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    // Счёт
                    Text("Score: \(score)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(16)
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal)
                Spacer()
                Button(action: { finishGame() }) {
                    Text("Finish")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(16)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            scene.scoreDidChange = { newScore in
                self.score = newScore
            }
            self.score = scene.score
        }
        .onDisappear {
            scene.score = 0
            scene.removeAllChildren()
            scene.isFirstSetup = true
        }
    }

    private func finishGame() {
        if score > bestScore {
            bestScore = score
        }
        dismiss()
    }
}

/// View representing a single bubble with emoji
struct BubbleView: View {
    let bubble: Bubble
    
    var body: some View {
        ZStack {
            Circle()
                .fill(bubble.color)
                .frame(width: 60, height: 60)
                .shadow(radius: 3)
            
            Text(bubble.emoji)
                .font(.system(size: 30))
        }
    }
}

#Preview {
    GameView()
} 
