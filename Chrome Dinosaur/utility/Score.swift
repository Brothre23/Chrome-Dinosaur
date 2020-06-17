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
    var currentScoreNode: SKNode!
    var highScoreNode: SKNode!
    var scoreFlashing: Bool!
    
    var parentScene: GameScene!
    
    init(parentScene: GameScene) {
        
        self.parentScene = parentScene
        
        hiLabel = SKSpriteNode(texture: Score.scoreTexture.textureNamed("HI"))
        // init(repeating:count:) does not work here!!!!!
        for _ in 0...4 {
            highScoreLabel.append(SKSpriteNode(texture: Score.scoreTexture.textureNamed("0")))
            currentScoreLabel.append(SKSpriteNode(texture: Score.scoreTexture.textureNamed("0")))
        }
        
        scoreFlashing = false
        
        currentScoreNode = SKNode()
        currentScoreNode.position = CGPoint(x: parentScene.size.width - 150, y: parentScene.size.height - 50)
        highScoreNode = SKNode()
        highScoreNode.position = CGPoint(x: currentScoreNode.position.x - 120, y: parentScene.size.height - 50)
        
        setPosition()
        
        highScoreNode.addChild(hiLabel)
        for i in 0..<highScoreLabel.count {
            highScoreNode.addChild(highScoreLabel[i])
        }
        for i in 0..<currentScoreLabel.count {
            currentScoreNode.addChild(currentScoreLabel[i])
        }
        
        parentScene.addChild(currentScoreNode)
        parentScene.addChild(highScoreNode)

    }
    
    func updateHighScore() {
        
        let highScoreArray = String(parentScene.highScore).digits
        if highScoreLabel.count < highScoreArray.count {
            highScoreLabel.insert(SKSpriteNode(texture: Score.scoreTexture.textureNamed("0")), at: 0)
            highScoreNode.addChild(highScoreLabel[0])
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
            currentScoreNode.addChild(currentScoreLabel[0])
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
    
    func flash() {

        let setInvisible = SKAction.fadeOut(withDuration: 0.2)
        let setVisible = SKAction.fadeIn(withDuration: 0.2)
        
        let flashAction = SKAction.repeat(SKAction.sequence([setInvisible, setVisible]), count: 3)
        
        self.currentScoreNode.run(flashAction) {
            self.scoreFlashing.toggle()
        }
    }
    
    func setPosition() {
        
        currentScoreLabel.last!.position = CGPoint(x: 100, y: 0)
        for i in (0...currentScoreLabel.count - 2).reversed() {
            currentScoreLabel[i].position = CGPoint(x: currentScoreLabel[i + 1].position.x - 20, y: 0)
        }
        
        highScoreNode.position = CGPoint(x: currentScoreNode.position.x - 120, y: parentScene.size.height - 50)
        
        highScoreLabel.last!.position = CGPoint(x: 100, y: 0)
        for i in (0...highScoreLabel.count - 2).reversed() {
            highScoreLabel[i].position = CGPoint(x: highScoreLabel[i + 1].position.x - 20, y: 0)
        }
        
        hiLabel.position = CGPoint(x: highScoreLabel[0].position.x - 50, y: 0)
    }

}
