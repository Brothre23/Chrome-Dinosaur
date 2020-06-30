//
//  Extension.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/6/14.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit

protocol ChangeSceneDelegate {
    func changeToGameScene(_ size: CGSize, _ type: String)
    func changeToStartScene(_ size: CGSize)
}

enum WalkingMode {
    case normal
    case down
}

enum BackgroundColor {
    case white
    case gray
}

extension String {
    var digits: [Int] { self.compactMap{ $0.wholeNumberValue } }
}

extension SKSpriteNode {
    func setPhysics(x: CGFloat, y: CGFloat, name: String) {
        if self.name != "dinosaur" {
            return
        }
        self.position = CGPoint(x: x, y: y)
        
        self.physicsBody = createPathBody(name, GameScene.dinoTexture.textureNamed(name))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        self.physicsBody?.categoryBitMask = GameScene.characterCategory
        self.physicsBody?.contactTestBitMask = GameScene.flyingEnemyCategory | GameScene.landEnemyCategory
        self.physicsBody?.collisionBitMask = 0
    }
}

func createPathBody(_ name: String, _ texture: SKTexture) -> SKPhysicsBody {
    let sprite = SKSpriteNode(texture: texture)
    
    let offsetX = sprite.size.width * sprite.anchorPoint.x
    let offsetY = sprite.size.height * sprite.anchorPoint.y
    
    let path = CGMutablePath()

    switch name {
    case "dinosaur_normal_1", "dinosaur_died":
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
    case "dinosaur_down_1":
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
    case "mario_normal_1":
        path.move(to: CGPoint(x: 15 - offsetX, y: 67 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y:  63 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y:  57 - offsetY))
        path.addLine(to: CGPoint(x: 3 - offsetX, y:  51 - offsetY))
        path.addLine(to: CGPoint(x: 5 - offsetX, y:  44 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y:  37 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 39 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 39 - offsetX, y:  38 - offsetY))
        path.addLine(to: CGPoint(x: 29 - offsetX, y:  39 - offsetY))
        path.addLine(to: CGPoint(x: 39 - offsetX, y:  45 - offsetY))
        path.addLine(to: CGPoint(x: 39 - offsetX, y:  61 - offsetY))
        path.addLine(to: CGPoint(x: 31 - offsetX, y:  67 - offsetY))
        path.closeSubpath()
    case "mario_died":
        path.move(to: CGPoint(x: 12 - offsetX, y: 71 - offsetY))
        path.addLine(to: CGPoint(x: 5 - offsetX, y:  65 - offsetY))
        path.addLine(to: CGPoint(x: 1 - offsetX, y:  56 - offsetY))
        path.addLine(to: CGPoint(x: 2 - offsetX, y:  48 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y:  45 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y:  36 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 17 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 19 - offsetX, y:  13 - offsetY))
        path.addLine(to: CGPoint(x: 22 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 38 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 38 - offsetX, y:  38 - offsetY))
        path.addLine(to: CGPoint(x: 31 - offsetX, y:  44 - offsetY))
        path.addLine(to: CGPoint(x: 38 - offsetX, y:  53 - offsetY))
        path.addLine(to: CGPoint(x: 36 - offsetX, y:  66 - offsetY))
        path.addLine(to: CGPoint(x: 30 - offsetX, y:  66 - offsetY))
        path.addLine(to: CGPoint(x: 29 - offsetX, y:  71 - offsetY))
        path.closeSubpath()
    case "mario_down_1":
        path.move(to: CGPoint(x: 15 - offsetX, y: 49 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y:  45 - offsetY))
        path.addLine(to: CGPoint(x: 9 - offsetX, y:  40 - offsetY))
        path.addLine(to: CGPoint(x: 3 - offsetX, y:  34 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y:  27 - offsetY))
        path.addLine(to: CGPoint(x: 0 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 39 - offsetX, y:  0 - offsetY))
        path.addLine(to: CGPoint(x: 39 - offsetX, y:  43 - offsetY))
        path.addLine(to: CGPoint(x: 32 - offsetX, y:  44 - offsetY))
        path.addLine(to: CGPoint(x: 32 - offsetX, y:  49 - offsetY))
    default:
        break
    }
    
    return SKPhysicsBody(polygonFrom: path)
}
