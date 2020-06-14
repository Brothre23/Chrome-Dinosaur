//
//  Score.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/5/9.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit

class Score {
    
    static let scoreTexture: SKTextureAtlas = SKTextureAtlas(named: "score")
    
    var hiLabel: SKSpriteNode!
    var highScoreLabel: [SKSpriteNode] = []
    var currentScoreLabel: [SKSpriteNode] = []
    
    var labelHeight: CGFloat!
    
    var parentScene: GameScene!
    
    init(parentScene: GameScene) {
        
        self.parentScene = parentScene
        
        hiLabel = SKSpriteNode(texture: Score.scoreTexture.textureNamed("HI"))
        // init(repeating:count:) does not work here!!!!!
        for _ in 0...4 {
            highScoreLabel.append(SKSpriteNode(texture: Score.scoreTexture.textureNamed("0")))
            currentScoreLabel.append(SKSpriteNode(texture: Score.scoreTexture.textureNamed("0")))
        }
        
        labelHeight = parentScene.size.height - 110.5
        setPosition()
        
        self.parentScene.addChild(hiLabel)
        for i in 0..<highScoreLabel.count {
            self.parentScene.addChild(highScoreLabel[i])
        }
        for i in 0..<currentScoreLabel.count {
            self.parentScene.addChild(currentScoreLabel[i])
        }

    }
    
    func updateHighScore() {
        
        let highScoreArray = String(parentScene.highScore).digits
        if highScoreLabel.count < highScoreArray.count {
            highScoreLabel.insert(SKSpriteNode(texture: Score.scoreTexture.textureNamed("0")), at: 0)
            parentScene.addChild(highScoreLabel[0])
            setPosition()
        }
        
        for i in 0..<highScoreArray.count {
            highScoreLabel[highScoreLabel.count - highScoreArray.count + i].texture = Score.scoreTexture.textureNamed(String(highScoreArray[i]))
        }
        
    }
    
    func updateScore() {
        
        let currentScoreArray = String(parentScene.currentScore).digits
        if currentScoreLabel.count < currentScoreArray.count {
            currentScoreLabel.insert(SKSpriteNode(texture: Score.scoreTexture.textureNamed("0")), at: 0)
            parentScene.addChild(currentScoreLabel[0])
            setPosition()
        }
        
        for i in 0..<currentScoreArray.count {
            currentScoreLabel[currentScoreLabel.count - currentScoreArray.count + i].texture = Score.scoreTexture.textureNamed(String(currentScoreArray[i]))
        }
        
    }
    
    func reset() {
        for label in currentScoreLabel {
            label.texture = Score.scoreTexture.textureNamed("0")
        }
    }
    
    func setPosition() {
        
        currentScoreLabel.last!.position = CGPoint(x: parentScene.size.width - 109, y: labelHeight)
        for i in (0...currentScoreLabel.count - 2).reversed() {
            currentScoreLabel[i].position = CGPoint(x: currentScoreLabel[i + 1].position.x - 20, y: labelHeight)
        }
        
        highScoreLabel.last!.position = CGPoint(x: currentScoreLabel.first!.position.x - 50, y: labelHeight)
        for i in (0...highScoreLabel.count - 2).reversed() {
            highScoreLabel[i].position = CGPoint(x: highScoreLabel[i + 1].position.x - 20, y: labelHeight)
        }
        
        hiLabel.position = CGPoint(x: highScoreLabel[0].position.x - 50, y: labelHeight)
    }

}
