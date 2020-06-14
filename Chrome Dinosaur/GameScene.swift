//
//  GameScene.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/4/12.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static let dinoTexture:SKTextureAtlas = SKTextureAtlas(named: "dinosaur")
    var landscape:SKSpriteNode!
    var dinosaur:SKSpriteNode!
    
    var moveSpeed:CGFloat!
    var currentScene:Scene!
    var enemyType:Bool!
    var lastTouchTime:CFTimeInterval!
    var lastEnemyTime:CFTimeInterval!
    var lastScoreTime: CFTimeInterval!
    var enemyWaitTime: Double!
    var currentWalkingMode:WalkingMode!
    
    static let characterCategory: UInt32 = 0x1 << 0
    static let flyingEnemyCategory: UInt32 = 0x1 << 1
    static let landEnemyCategory: UInt32 = 0x1 << 2
    
    var currentScore: Int!
    var highScore: Int!
    
    var userDefault: UserDefaults!
    var score: Score!
    
    var normalWalkForever:SKAction!
    var downWalkForever:SKAction!
    
    enum WalkingMode {
        case normal
        case down
    }
    
    enum Scene {
        case desert
        case metro
        case outerspace
    }
    
    func setupDinosaur() {
        let normalWalkOnce = SKAction.animate(with: [GameScene.dinoTexture.textureNamed("normal_1.png"), GameScene.dinoTexture.textureNamed("normal_2.png")], timePerFrame: 0.1, resize: true, restore: false)
        normalWalkForever = SKAction.repeatForever(normalWalkOnce)

        let downWalkOnce = SKAction.animate(with: [GameScene.dinoTexture.textureNamed("down_1.png"), GameScene.dinoTexture.textureNamed("down_2.png")], timePerFrame: 0.1, resize: true, restore: false)
        downWalkForever = SKAction.repeatForever(downWalkOnce)
        
        dinosaur = SKSpriteNode(texture: GameScene.dinoTexture.textureNamed("normal_2.png"))
        
        dinosaur.name = "dinosaur"
        dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2, name: "normal_1")
        
        dinosaur.run(normalWalkForever)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.physicsWorld.contactDelegate = self
        
        moveSpeed = 10
        currentScene = .desert
        lastTouchTime = 0
        lastEnemyTime = 0
        lastScoreTime = 0
        currentScore = Int(-moveSpeed)
        currentWalkingMode = .normal
        
        userDefault = UserDefaults()
        highScore = userDefault.integer(forKey: "high score")
        
        score = Score(parentScene: self)
    }
    
    override func didMove(to view: SKView) {
        for i in 0...1 {
            landscape = SKSpriteNode(imageNamed: "landscape")
            landscape.name = "landscape"
            landscape.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            landscape.position = CGPoint(x: CGFloat(i) * landscape.size.width, y: 0.0)
            
            self.addChild(landscape)
        }
        
        setupDinosaur()
        self.addChild(dinosaur)
        
        score.updateHighScore()
        
        self.isPaused = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        enemyWaitTime = Double.random(in: 1...3)
        if currentTime - lastEnemyTime > enemyWaitTime {
            var enemy:SKSpriteNode!
            enemyType = Bool.random()

            switch currentScene {
            case .desert:
                if self.enemyType {
                    enemy = Enemy(type: "cactus")
                    enemy.position = CGPoint(x: self.size.width + enemy.size.width / 2, y: self.landscape.size.height / 4 + enemy.size.height / 2)
                }
                else {
                    enemy = Enemy(type: "bird")
                    let yPosition = CGFloat.random(in: self.landscape.size.height + enemy.size.height / 2...self.size.height / 2 - enemy.size.height / 2)
                    enemy.position = CGPoint(x: self.size.width + enemy.size.width / 2, y: yPosition)
                }
            default:
                break
            }
            self.addChild(enemy)

            lastEnemyTime = currentTime
        }
        
        if currentTime - lastScoreTime > 0.5 {
            currentScore += Int(moveSpeed)
            score.updateScore()
            
            lastScoreTime = currentTime
        }
        
        self.enumerateChildNodes(withName: "landscape") {
            (node, stop) in
            
            let newLandscape = node as! SKSpriteNode
            newLandscape.position.x -= self.moveSpeed
           
            if newLandscape.position.x <= -newLandscape.size.width {
                newLandscape.position.x += newLandscape.size.width * 2
            }
        }
        
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            
            let enemy = node as! SKSpriteNode
            enemy.position.x -= self.moveSpeed
         
            if enemy.position.x <= -enemy.size.width / 2 {
                enemy.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPaused {
            let touch:UITouch = touches.first!
            let positionInScene = touch.location(in: self)
            let touchedNode = self.nodes(at: positionInScene)
            
            if !touchedNode.isEmpty
            {
                let name = touchedNode[0].name
                if name == "GGButton" {
                    let GGLabel = childNode(withName: "GGLabel")
                    GGLabel?.removeFromParent()
                    
                    let GGButton = touchedNode[0]
                    GGButton.removeFromParent()
                    
                    self.enumerateChildNodes(withName: "enemy") {
                        (node, _) in
                        node.removeFromParent()
                    }
                    
                    currentWalkingMode = .normal
                    
                    currentScore = Int(-moveSpeed)
                    score.updateHighScore()
                    score.reset()
                    
                    dinosaur.position = CGPoint(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2)
                    dinosaur.run(normalWalkForever)
                    
                    self.isPaused.toggle()
                }
                else {
                    return
                }
            }
            else {
                return
            }
        }
        else {
            switch touches.count {
            case 1:
                if CACurrentMediaTime() - lastTouchTime < 0.6 || currentWalkingMode == .down {
                    return
                }
                
                lastTouchTime = CACurrentMediaTime()
                
                let setJumpTexture = SKAction.setTexture(GameScene.dinoTexture.textureNamed("jump.png"))
                let setWalkTexture = SKAction.setTexture(GameScene.dinoTexture.textureNamed("normal_2.png"))
                let jumpUp = SKAction.moveBy(x: 0, y: 150, duration: 0.4)
                let jumpDown = SKAction.moveBy(x: 0, y: -150, duration: 0.2)
                
                dinosaur.removeAllActions()
                let completion = SKAction.run {
                    self.dinosaur.run(self.normalWalkForever)
                }
                dinosaur.run(SKAction.sequence([setJumpTexture, jumpUp, jumpDown, setWalkTexture, completion]))
            case 2:
                switch currentWalkingMode {
                case .down:
                    dinosaur.removeAllActions()
                    dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + GameScene.dinoTexture.textureNamed("normal_1").size().height / 2, name: "normal_1")
                    dinosaur.run(normalWalkForever)
                    currentWalkingMode = .normal
                case .normal:
                    dinosaur.removeAllActions()
                    dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + GameScene.dinoTexture.textureNamed("down_1").size().height / 2, name: "down_1")
                    dinosaur.run(downWalkForever)
                    currentWalkingMode = .down
                default:
                    break
                }
                break
            default:
                break
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let gameOverLabel = SKSpriteNode(imageNamed: "GG.png")
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverLabel.name = "GGLabel"
        let restartLabel = SKSpriteNode(imageNamed: "restart.png")
        restartLabel.position = CGPoint(x: self.size.width / 2, y: gameOverLabel.position.y - 100)
        restartLabel.name = "GGButton"
        
        dinosaur.removeAllActions()
        dinosaur.texture = GameScene.dinoTexture.textureNamed("died.png")
        dinosaur.size = CGSize(width: GameScene.dinoTexture.textureNamed("died.png").size().width, height: GameScene.dinoTexture.textureNamed("died.png").size().height)
        switch currentWalkingMode {
        case .down:
            dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2, name: "died")
        case .normal:
            dinosaur.setPhysics(x: dinosaur.position.x, y: dinosaur.position.y, name: "died")
        default:
            break
        }

        self.addChild(gameOverLabel)
        self.addChild(restartLabel)
        
        if currentScore > highScore {
            highScore = currentScore
            userDefault.set(highScore, forKey: "high score")
        }
        
        self.isPaused.toggle()
    }
}
