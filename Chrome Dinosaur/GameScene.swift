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
    
    let characterCategory: UInt32 = 0x1 << 0
    let flyingEnemyCategory: UInt32 = 0x1 << 1
    let landEnemyCategory: UInt32 = 0x1 << 2
    
    var walkForever:SKAction!
    
    var lastTouchTime:CFTimeInterval!
    
    enum Scene {
        case desert
        case metro
        case outerspace
    }
    
    enum Cactus: CaseIterable {
        case small_1
        case small_2
        case small_3
        case big_1
        case big_2
        case big_4
    }
    
    func newEnemy() {
        let wait = SKAction.wait(forDuration: 2, withRange: 2)
        var enemy:SKSpriteNode!
        
        let spawn = SKAction.run {
            self.enemyType = Bool.random()
            
            switch self.currentScene {
            case .desert:
                if self.enemyType {
                    enemy = self.newCactus()
                }
                else {
                    enemy = self.newBird()
                }
            default:
                break
            }
            
            self.addChild(enemy)
        }
        if !self.isPaused {
            self.run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
        }
    }
    
    func newCactus() -> SKSpriteNode {
        let randomCactus = Cactus.allCases.randomElement()!
        var newCactus:SKSpriteNode!
        
        switch randomCactus {
        case .small_1:
            newCactus = SKSpriteNode(texture: dinoTexture.textureNamed("cactus_small_1.png"))
        case .small_2:
            newCactus = SKSpriteNode(texture: dinoTexture.textureNamed("cactus_small_2.png"))
        case .small_3:
            newCactus = SKSpriteNode(texture: dinoTexture.textureNamed("cactus_small_3.png"))
        case .big_1:
            newCactus = SKSpriteNode(texture: dinoTexture.textureNamed("cactus_big_1.png"))
        case .big_2:
            newCactus = SKSpriteNode(texture: dinoTexture.textureNamed("cactus_big_2.png"))
        case .big_4:
            newCactus = SKSpriteNode(texture: dinoTexture.textureNamed("cactus_big_4.png"))
        }
        
        newCactus.setScale(0.75)
        newCactus.anchorPoint = CGPoint(x: 0, y: 0)
        newCactus.position = CGPoint(x: size.width, y: landscape.size.height / 4)
        newCactus.name = "enemy"
        
        newCactus.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newCactus.size.width, height: newCactus.size.height))
        newCactus.physicsBody?.affectedByGravity = false
        
        newCactus.physicsBody?.categoryBitMask = landEnemyCategory
        newCactus.physicsBody?.contactTestBitMask = characterCategory
        newCactus.physicsBody?.collisionBitMask = 0
        
        return newCactus
    }
    
    func newBird() -> SKSpriteNode {
        let newBird = SKSpriteNode(texture: dinoTexture.textureNamed("bird_2.png"))
        newBird.setScale(0.75)
        let yPosition = CGFloat.random(in: landscape.size.height + newBird.size.height / 2...size.height / 2 - newBird.size.height / 2)
        
        let flyOnce = SKAction.sequence([SKAction.moveBy(x: 0, y: -12, duration: 0), SKAction.setTexture(dinoTexture.textureNamed("bird_1.png"), resize: true), SKAction.wait(forDuration: 0.2),
            SKAction.moveBy(x: 0, y: 12, duration: 0),
            SKAction.setTexture(dinoTexture.textureNamed("bird_2.png"), resize: true),
            SKAction.wait(forDuration: 0.2)])
        let flyForever = SKAction.repeatForever(flyOnce)
        
        newBird.position = CGPoint(x: size.width, y: yPosition)
        newBird.run(flyForever)
        newBird.name = "enemy"
        
        newBird.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: newBird.size.width, height: newBird.size.height))
        newBird.physicsBody?.affectedByGravity = false
        
        newBird.physicsBody?.categoryBitMask = flyingEnemyCategory
        newBird.physicsBody?.contactTestBitMask = characterCategory
        newBird.physicsBody?.collisionBitMask = 0
        
        return newBird
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.physicsWorld.contactDelegate = self
        
        dinoTexture = SKTextureAtlas(named: "dinosaur")
        moveSpeed = 5
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
        
        let walkOnce = SKAction.animate(with: [dinoTexture.textureNamed("walk_1.png"), dinoTexture.textureNamed("walk_2.png")], timePerFrame: 0.2)
        walkForever = SKAction.repeatForever(walkOnce)
        
        dinosaur = SKSpriteNode(texture: dinoTexture.textureNamed("walk_2.png"))
        
        dinosaur.setScale(0.75)
        dinosaur.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        dinosaur.position = CGPoint(x: 100, y: landscape.size.height / 4)
        dinosaur.name = "dinosaur"
        
        dinosaur.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dinosaur.size.width, height: dinosaur.size.height))
        dinosaur.physicsBody?.affectedByGravity = false
        
        dinosaur.physicsBody?.categoryBitMask = characterCategory
        dinosaur.physicsBody?.contactTestBitMask = flyingEnemyCategory | landEnemyCategory
        dinosaur.physicsBody?.collisionBitMask = 0
        
        dinosaur.run(walkForever, withKey: "dinosaurWalk")
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
            self.enumerateChildNodes(withName: "GG") {
                (node, _) in
                node.removeFromParent()
            }
            
            self.enumerateChildNodes(withName: "enemy") {
                (node, _) in
                node.removeFromParent()
            }
            
            dinosaur.run(SKAction.setTexture(dinoTexture.textureNamed("walk_2.png")))
            self.isPaused.toggle()
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
            dinosaur.run(SKAction.sequence([setJumpTexture, jumpUp, jumpDown, setWalkTexture]), completion: {
                self.dinosaur.run(self.walkForever, withKey: "dinosaurWalk")
            })
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
//        self.isPaused.toggle()
//
//        let gameOverLabel = SKSpriteNode(imageNamed: "GG.png")
//        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
//        gameOverLabel.name = "GG"
//        let restartLabel = SKSpriteNode(imageNamed: "restart.png")
//        restartLabel.position = CGPoint(x: self.size.width / 2, y: gameOverLabel.position.y - 100)
//        restartLabel.name = "GG"
//
//        self.addChild(gameOverLabel)
//        self.addChild(restartLabel)
    }
}
