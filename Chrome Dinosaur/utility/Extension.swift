//
//  Extension.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/6/14.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit

extension String {
    var digits: [Int] { self.compactMap{ $0.wholeNumberValue } }
}

extension SKSpriteNode {
    func setPhysics(x: CGFloat, y: CGFloat, name: String) {
        if self.name != "dinosaur" {
            return
        }
        self.position = CGPoint(x: x, y: y)
        
        self.physicsBody = GameScene.dinoTexture.textureNamed(name).createPathBody(name)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.physicsBody?.categoryBitMask = GameScene.characterCategory
        self.physicsBody?.contactTestBitMask = GameScene.flyingEnemyCategory | GameScene.landEnemyCategory
        self.physicsBody?.collisionBitMask = 0
    }
}

extension SKTexture {
    func createPathBody(_ name: String) -> SKPhysicsBody {
        let sprite = SKSpriteNode(texture: self)
        
        let offsetX = sprite.size.width * sprite.anchorPoint.x
        let offsetY = sprite.size.height * sprite.anchorPoint.y
        
        let path = CGMutablePath()

        switch name {
        case "normal_1", "died":
            path.move(to: CGPoint(x: 28 - offsetX, y: 71 - offsetY))
            path.addLine(to: CGPoint(x: 28 - offsetX, y:  50 - offsetY))
            path.addLine(to: CGPoint(x: 16 - offsetX, y:  42 - offsetY))
            path.addLine(to: CGPoint(x: 10 - offsetX, y:  42 - offsetY))
            path.addLine(to: CGPoint(x: 10 - offsetX, y:  48 - offsetY))
            path.addLine(to: CGPoint(x: 0 - offsetX, y:  48 - offsetY))
            path.addLine(to: CGPoint(x: 0 - offsetX, y:  24 - offsetY))
            path.addLine(to: CGPoint(x: 12 - offsetX, y:  12 - offsetY))
            path.addLine(to: CGPoint(x: 13 - offsetX, y:  0 - offsetY))
            path.addLine(to: CGPoint(x: 50 - offsetX, y:  0 - offsetY))
            path.addLine(to: CGPoint(x: 50 - offsetX, y:  28 - offsetY))
            path.addLine(to: CGPoint(x: 56 - offsetX, y:  28 - offsetY))
            path.addLine(to: CGPoint(x: 56 - offsetX, y:  40 - offsetY))
            path.addLine(to: CGPoint(x: 62 - offsetX, y:  40 - offsetY))
            path.addLine(to: CGPoint(x: 62 - offsetX, y:  46 - offsetY))
            path.addLine(to: CGPoint(x: 65 - offsetX, y:  46 - offsetY))
            path.addLine(to: CGPoint(x: 65 - offsetX, y:  70 - offsetY))
            path.closeSubpath()
        case "down_1":
            path.move(to: CGPoint(x: 0 - offsetX, y: 27 - offsetY))
            path.addLine(to: CGPoint(x: 11 - offsetX, y:  16 - offsetY))
            path.addLine(to: CGPoint(x: 10 - offsetX, y:  0 - offsetY))
            path.addLine(to: CGPoint(x: 43 - offsetX, y:  0 - offsetY))
            path.addLine(to: CGPoint(x: 43 - offsetX, y:  5 - offsetY))
            path.addLine(to: CGPoint(x: 59 - offsetX, y:  5 - offsetY))
            path.addLine(to: CGPoint(x: 60 - offsetX, y:  12 - offsetY))
            path.addLine(to: CGPoint(x: 88 - offsetX, y:  11 - offsetY))
            path.addLine(to: CGPoint(x: 88 - offsetX, y:  44 - offsetY))
            path.addLine(to: CGPoint(x: 0 - offsetX, y:  45 - offsetY))
            path.closeSubpath()
        default:
            break
        }
        
        return SKPhysicsBody(polygonFrom: path)
    }
}
