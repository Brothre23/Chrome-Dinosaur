//
//  GameScene.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/4/12.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var dinoTexture:SKTextureAtlas!
    var landscape:SKSpriteNode!
    var dinosaur:SKSpriteNode!
    
    var moveSpeed:CGFloat!
    var currentScene:Scene!
    var enemyType:Bool!
    var lastTouchTime:CFTimeInterval!
    
    let characterCategory: UInt32 = 0x1 << 0
    let flyingEnemyCategory: UInt32 = 0x1 << 1
    let landEnemyCategory: UInt32 = 0x1 << 2
    
    var walkForever:SKAction!
    
    enum Scene {
        case desert
        case metro
        case outerspace
    }
    
    func newEnemy() {
        let wait = SKAction.wait(forDuration: 2, withRange: 2)
        var enemy:SKSpriteNode!
        
        let spawn = SKAction.run {
            self.enemyType = Bool.random()
            
            switch self.currentScene {
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
        }
        self.run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
    }
    
    func setupDinosaur() {
        let walkOnce = SKAction.animate(with: [dinoTexture.textureNamed("walk_1.png"), dinoTexture.textureNamed("walk_2.png")], timePerFrame: 0.1)
        walkForever = SKAction.repeatForever(walkOnce)
        
        dinosaur = SKSpriteNode(texture: dinoTexture.textureNamed("walk_2.png"))
        
        dinosaur.setScale(0.75)
        dinosaur.position = CGPoint(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2)
        dinosaur.name = "dinosaur"
        
        dinosaur.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dinosaur.size.width, height: dinosaur.size.height))
        // dinosaur.physicsBody = SKPhysicsBody(texture: dinosaur.texture!, size: dinosaur.texture!.size())
        dinosaur.physicsBody?.affectedByGravity = false
        dinosaur.physicsBody?.usesPreciseCollisionDetection = true
        
        dinosaur.physicsBody?.categoryBitMask = characterCategory
        dinosaur.physicsBody?.contactTestBitMask = flyingEnemyCategory | landEnemyCategory
        dinosaur.physicsBody?.collisionBitMask = 0
        
        dinosaur.run(walkForever, withKey: "dinosaurWalk")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        self.physicsWorld.contactDelegate = self
        
        dinoTexture = SKTextureAtlas(named: "dinosaur")
        moveSpeed = 10
        currentScene = .desert
        lastTouchTime = 0
        self.isPaused = false
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
        newEnemy()
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.enumerateChildNodes(withName: "landscape") {
            (node, stop) in
            
            let newLandscape = node as! SKSpriteNode
            newLandscape.position.x -= self.moveSpeed
            
            if (newLandscape.position.x <= -newLandscape.size.width) {
                newLandscape.position.x += newLandscape.size.width * 2
            }
        }
        
        self.enumerateChildNodes(withName: "enemy") {
            (node, stop) in
            
            let enemy = node as! SKSpriteNode
            enemy.position.x -= self.moveSpeed
            
            if (enemy.position.x <= -enemy.size.width / 2) {
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
                    
                    dinosaur.removeAction(forKey: "dinosaurJump")
                    dinosaur.position = CGPoint(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2)
                    dinosaur.run(walkForever, withKey: "dinosaurWalk")
                    
                    self.isPaused.toggle()
                }
            }
            else {
                return
            }
        }
        else {
            let setJumpTexture = SKAction.setTexture(dinoTexture.textureNamed("jump.png"))
            let setWalkTexture = SKAction.setTexture(dinoTexture.textureNamed("walk_2.png"))
            let jumpUp = SKAction.moveBy(x: 0, y: 150, duration: 0.5)
            let jumpDown = SKAction.moveBy(x: 0, y: -150, duration: 0.25)
            
            if (CACurrentMediaTime() - lastTouchTime < 0.75) {
                return
            }
            
            lastTouchTime = CACurrentMediaTime()
            
            dinosaur.removeAction(forKey: "dinosaurWalk")
            let completion = SKAction.run {
                self.dinosaur.run(self.walkForever, withKey: "dinosaurWalk")
            }
            dinosaur.run(SKAction.sequence([setJumpTexture, jumpUp, jumpDown, setWalkTexture, completion]), withKey: "dinosaurJump")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        self.isPaused.toggle()

        let gameOverLabel = SKSpriteNode(imageNamed: "GG.png")
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverLabel.name = "GGLabel"
        let restartLabel = SKSpriteNode(imageNamed: "restart.png")
        restartLabel.position = CGPoint(x: self.size.width / 2, y: gameOverLabel.position.y - 100)
        restartLabel.name = "GGButton"
        
        dinosaur.texture = dinoTexture.textureNamed("died.png")

        self.addChild(gameOverLabel)
        self.addChild(restartLabel)
    }
}
