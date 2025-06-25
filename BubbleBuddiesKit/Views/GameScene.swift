import SpriteKit

class GameScene: SKScene {
    private let rows = 12
    private let cols = 8
    private var bubbleSize: CGFloat = 0
    private let spacing: CGFloat = 10
    private let borderPadding: CGFloat = 20 // отступ от краёв
    private var bubbleGrid: [[SKShapeNode?]] = []
    private let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPink] // только 4 цвета
    private let emojis = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"]
     var isFirstSetup = true
    // Для платформы
    private var fieldWidth: CGFloat = 0
    private var fieldHeight: CGFloat = 0
    private var offsetX: CGFloat = 0
    private var offsetY: CGFloat = 0
    // Счет
    var score: Int = 0 {
        didSet {
            scoreDidChange?(score)
        }
    }
    var scoreDidChange: ((Int) -> Void)?

    override func didMove(to view: SKView) {
        // Добавляем цветной фон через SKSpriteNode
        let bg = SKSpriteNode(texture: gradientTexture(size: size))
        bg.size = size
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = -1000
        addChild(bg)
        self.backgroundColor = .clear
        if isFirstSetup {
            setupPhysics()
            calculateFieldGeometry()
            addBottomPlatform()
            generateBubbles()
            isFirstSetup = false
        }
    }

    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
    }

    private func calculateFieldGeometry() {
        // bubbleSize вычисляется так, чтобы пузыри заполняли всю ширину экрана
        let totalSpacing = CGFloat(cols - 1) * spacing
        bubbleSize = (size.width - 2 * borderPadding - totalSpacing) / CGFloat(cols)
        fieldWidth = CGFloat(cols) * bubbleSize + CGFloat(cols - 1) * spacing
        fieldHeight = CGFloat(rows) * bubbleSize + CGFloat(rows - 1) * spacing
        offsetX = borderPadding
        // Центрируем по вертикали
        offsetY = (size.height - fieldHeight) / 2
    }

    private func addBottomPlatform() {
        let platform = SKNode()
        // Платформа ровно под сеткой
        platform.position = CGPoint(
            x: size.width/2,
            y: size.height - (offsetY + fieldHeight) + bubbleSize/2
        )
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: fieldWidth, height: bubbleSize))
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.categoryBitMask = PhysicsCategory.platform
        addChild(platform)
    }

    private func generateBubbles() {
        bubbleGrid = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        for row in 0..<rows {
            for col in 0..<cols {
                let emoji = (Double.random(in: 0...1) < 0.2 ? (emojis.randomElement() ?? "") : "")
                let bubble = createBubble(
                    at: CGPoint(
                        x: offsetX + CGFloat(col) * (bubbleSize + spacing) + bubbleSize/2,
                        y: size.height - (offsetY + CGFloat(row) * (bubbleSize + spacing) + bubbleSize/2)
                    ),
                    color: colors.randomElement() ?? .systemBlue,
                    emoji: emoji
                )
                bubbleGrid[row][col] = bubble
                addChild(bubble)
            }
        }
    }

    private func createBubble(at position: CGPoint, color: UIColor, emoji: String) -> SKShapeNode {
        let bubble = SKShapeNode(circleOfRadius: bubbleSize/2)
        bubble.position = position
        bubble.fillColor = color
        bubble.strokeColor = .clear
        bubble.name = "bubble"
        
        // Add physics body
        bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubbleSize/2)
        bubble.physicsBody?.isDynamic = false
        bubble.physicsBody?.categoryBitMask = PhysicsCategory.bubble
        bubble.physicsBody?.contactTestBitMask = PhysicsCategory.bubble | PhysicsCategory.platform
        bubble.physicsBody?.collisionBitMask = PhysicsCategory.bubble | PhysicsCategory.platform
        
        // Add emoji label (только если не пусто)
        if !emoji.isEmpty {
            let label = SKLabelNode(text: emoji)
            label.fontSize = bubbleSize * 0.5
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.name = "emojiLabel"
            bubble.addChild(label)
        }
        
        // Store color for chain reaction
        bubble.userData = NSMutableDictionary()
        bubble.userData?.setValue(color, forKey: "color")
        bubble.userData?.setValue(emoji, forKey: "emoji")
        
        return bubble
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for row in 0..<rows {
            for col in 0..<cols {
                if let bubble = bubbleGrid[row][col], bubble.contains(location) {
                    let group = findGroup(row: row, col: col, color: bubble.fillColor)
                    if group.count >= 3 {
                        // 1. Сначала удаляем все из сетки и анимируем исчезновение
                        for pos in group {
                            let r = pos[0], c = pos[1]
                            if let bubble = bubbleGrid[r][c] {
                                // Если есть животное — +1 очко и анимация
                                if let emoji = bubble.userData?.value(forKey: "emoji") as? String, !emoji.isEmpty,
                                   let label = bubble.childNode(withName: "emojiLabel") as? SKLabelNode {
                                    score += 1
                                    // Переводим label в координаты сцены
                                    let labelPositionInScene = bubble.convert(label.position, to: self)
                                    label.removeFromParent()
                                    label.position = labelPositionInScene
                                    self.addChild(label)
                                    // Анимация
                                    let scaleUp = SKAction.scale(to: 2.0, duration: 0.18)
                                    let moveDown = SKAction.moveBy(x: 0, y: -size.height, duration: 0.6)
                                    moveDown.timingMode = .easeIn
                                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                                    let group = SKAction.group([moveDown, fadeOut])
                                    let remove = SKAction.removeFromParent()
                                    let sequence = SKAction.sequence([scaleUp, group, remove])
                                    label.run(sequence)
                                }
                                let scaleDown = SKAction.scale(to: 0.1, duration: 0.2)
                                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                                let remove = SKAction.removeFromParent()
                                bubble.run(SKAction.sequence([SKAction.group([scaleDown, fadeOut]), remove]))
                                bubbleGrid[r][c] = nil
                            }
                        }
                        // 2. После этого сдвигаем все оставшиеся пузыри вниз
                        applyGravityToAllColumns()
                    }
                    return
                }
            }
        }
    }

    // Сдвиг пузырей вниз во всех столбцах
    private func applyGravityToAllColumns() {
        for col in 0..<cols {
            var emptyRow: Int? = nil
            for row in (0..<rows).reversed() {
                if bubbleGrid[row][col] == nil {
                    if emptyRow == nil { emptyRow = row }
                } else if let empty = emptyRow {
                    // Сдвигаем пузырь вниз
                    let bubble = bubbleGrid[row][col]!
                    let newY = bubble.position.y - CGFloat(empty - row) * (bubbleSize + spacing)
                    let move = SKAction.moveTo(y: newY, duration: 0.2)
                    bubble.run(move)
                    bubbleGrid[empty][col] = bubble
                    bubbleGrid[row][col] = nil
                    emptyRow = empty - 1
                }
            }
        }
    }

    // Флуд-филл для поиска группы одинаковых пузырей
    private func findGroup(row: Int, col: Int, color: SKColor) -> Set<[Int]> {
        var visited = Set<[Int]>()
        var stack = [[row, col]]
        while let pos = stack.popLast() {
            let r = pos[0], c = pos[1]
            guard r >= 0, r < rows, c >= 0, c < cols else { continue }
            guard let bubble = bubbleGrid[r][c], bubble.fillColor == color else { continue }
            if visited.contains([r, c]) { continue }
            visited.insert([r, c])
            for (dr, dc) in [(-1,0),(1,0),(0,-1),(0,1)] {
                stack.append([r+dr, c+dc])
            }
        }
        return visited
    }

    // Функция для создания градиентной текстуры
    private func gradientTexture(size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0, 1])!
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
        }
        return SKTexture(image: image)
    }
}

// Physics categories
struct PhysicsCategory {
    static let bubble: UInt32 = 0x1 << 0
    static let platform: UInt32 = 0x1 << 1
}

// Physics contact delegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // When a falling bubble lands, make it static again
        let (bubbleNode, otherNode): (SKNode, SKNode) =
            (contact.bodyA.categoryBitMask == PhysicsCategory.bubble) ? (contact.bodyA.node!, contact.bodyB.node!) : (contact.bodyB.node!, contact.bodyA.node!)
        
        if let bubble = bubbleNode as? SKShapeNode,
           otherNode.physicsBody?.categoryBitMask == PhysicsCategory.platform || otherNode.physicsBody?.categoryBitMask == PhysicsCategory.bubble {
            bubble.physicsBody?.isDynamic = false
            bubble.physicsBody?.velocity = .zero
            bubble.physicsBody?.angularVelocity = 0
        }
    }
} 
