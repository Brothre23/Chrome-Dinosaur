//
//  Enemy.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/5/6.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    static let enemyTexture: SKTextureAtlas = SKTextureAtlas(named: "enemy")
    static let characterCategory: UInt32 = 0x1 << 0
    static let flyingEnemyCategory: UInt32 = 0x1 << 1
    static let landEnemyCategory: UInt32 = 0x1 << 2
    
    var tempTexture:SKTexture!
    
    enum Cactus: CaseIterable {
        case small_1
        case small_2
        case small_3
        case big_1
        case big_2
        case big_4
    }
    
    init(type: String) {
        let texture = Enemy.enemyTexture.textureNamed("Sprite")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        switch type {
        case "cactus":
            let randomCactus = Cactus.allCases.randomElement()!
            
            switch randomCactus {
            case .small_1:
                tempTexture = Enemy.enemyTexture.textureNamed("cactus_small_1.png")
                self.texture = tempTexture
                self.size = tempTexture.size()
            case .small_2:
                tempTexture = Enemy.enemyTexture.textureNamed("cactus_small_2.png")
                self.texture = tempTexture
                self.size = tempTexture.size()
            case .small_3:
                tempTexture = Enemy.enemyTexture.textureNamed("cactus_small_3.png")
                self.texture = tempTexture
                self.size = tempTexture.size()
            case .big_1:
                tempTexture = Enemy.enemyTexture.textureNamed("cactus_big_1.png")
                self.texture = tempTexture
                self.size = tempTexture.size()
            case .big_2:
                tempTexture = Enemy.enemyTexture.textureNamed("cactus_big_2.png")
                self.texture = tempTexture
                self.size = tempTexture.size()
            case .big_4:
                tempTexture = Enemy.enemyTexture.textureNamed("cactus_big_4.png")
                self.texture = tempTexture
                self.size = tempTexture.size()
            }
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
            self.physicsBody?.categoryBitMask = Enemy.landEnemyCategory
            
        case "bird":
            let flyOnce = SKAction.sequence([SKAction.moveBy(x: 0, y: -12, duration: 0), SKAction.setTexture(Enemy.enemyTexture.textureNamed("bird_1.png"), resize: true), SKAction.wait(forDuration: 0.2),
                SKAction.moveBy(x: 0, y: 12, duration: 0),
                SKAction.setTexture(Enemy.enemyTexture.textureNamed("bird_2.png"), resize: true),
                SKAction.wait(forDuration: 0.2)])
            let flyForever = SKAction.repeatForever(flyOnce)
            
            tempTexture = Enemy.enemyTexture.textureNamed("bird_2.png")
            self.texture = tempTexture
            self.size = tempTexture.size()
            
            self.run(flyForever)
            
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
            self.physicsBody?.categoryBitMask = Enemy.flyingEnemyCategory
            
        default:
            break
        }

        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.contactTestBitMask = Enemy.characterCategory
        self.physicsBody?.collisionBitMask = 0
        self.name = "enemy"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
