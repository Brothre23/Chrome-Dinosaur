//
//  GameScene.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/4/12.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var dinoTexture:SKTextureAtlas!
    var landscape:SKSpriteNode!
    var dinosaur:SKSpriteNode!
    
    var moveSpeed:CGFloat!
    var currentScene:Scene!
    var enemyType:Bool!
    
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
    
    func jumpAction() -> SKAction {
        let beforeJump = SKAction.setTexture(dinoTexture.textureNamed("jump.png"))
        let afterJump = SKAction.setTexture(dinoTexture.textureNamed("walk_2.png"))
        let jumpAll = SKAction.sequence([beforeJump, SKAction.moveBy(x: 0, y: 150, duration: 0.25), SKAction.moveBy(x: 0, y: -150, duration: 0.25), afterJump])
        
        return jumpAll
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
        self.run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
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
        newCactus.position = CGPoint(x: size.width + newCactus.size.width / 2, y: landscape.size.height / 4 + newCactus.size.height / 2)
        newCactus.name = "enemy"
        
        return newCactus
    }
    
    func newBird() -> SKSpriteNode {
        let newBird = SKSpriteNode(texture: dinoTexture.textureNamed("bird_2.png"))
        newBird.setScale(0.75)
        let yPosition = CGFloat.random(in: size.height / 2 + newBird.size.height / 2...size.height - newBird.size.height / 2)
        
        let flyOnce = SKAction.sequence([SKAction.moveBy(x: 0, y: -12, duration: 0), SKAction.setTexture(dinoTexture.textureNamed("bird_1.png"), resize: true), SKAction.wait(forDuration: 0.2),
            SKAction.moveBy(x: 0, y: 12, duration: 0),
            SKAction.setTexture(dinoTexture.textureNamed("bird_2.png"), resize: true),
            SKAction.wait(forDuration: 0.2)])
        let flyForever = SKAction.repeatForever(flyOnce)
        
        newBird.position = CGPoint(x: size.width + newBird.size.width / 2, y: yPosition)
        newBird.run(flyForever)
        newBird.name = "enemy"
        
        return newBird
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        dinoTexture = SKTextureAtlas(named: "dinosaur")
        moveSpeed = 5
        currentScene = .desert
    }
    
    override func didMove(to view: SKView) {
        for i in 0...1 {
            landscape = SKSpriteNode(imageNamed: "landscape")
            landscape.name = "landscape"
            landscape.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            landscape.position = CGPoint(x: CGFloat(i) * landscape.size.width, y: 0.0)
            
            self.addChild(landscape)
        }
        
        let walkOnce = SKAction.animate(with: [dinoTexture.textureNamed("walk_1.png"), dinoTexture.textureNamed("walk_2.png")], timePerFrame: 0.1)
        let walkForever = SKAction.repeatForever(walkOnce)
        
        dinosaur = SKSpriteNode(texture: dinoTexture.textureNamed("walk_2.png"))
        dinosaur.setScale(0.75)
        dinosaur.position = CGPoint(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2)
        dinosaur.name = "dinosaur"
        dinosaur.run(walkForever)
        
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
        let jump = jumpAction()
        let dinosaur = self.childNode(withName: "dinosaur")
        dinosaur?.run(jump)
    }
}
