//
//  StartScene.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/6/24.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    static let dinoTexture: SKTextureAtlas = SKTextureAtlas(named: "dinosaur")
    var landscape: SKSpriteNode!
    var dinosaur: SKSpriteNode!
    var gameScene: GameScene!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = UIColor.white
        gameScene = GameScene(size: self.size)
    }
    
    override func didMove(to view: SKView) {
        
        landscape = SKSpriteNode(imageNamed: "landscape")
        landscape.position = CGPoint(x: self.size.width / 2, y: landscape.size.height * 0.5)
        
        dinosaur = SKSpriteNode(texture: GameScene.dinoTexture.textureNamed("died.png"))
        dinosaur.position = CGPoint(x: 100, y: dinosaur.size.height / 2 + landscape.size.height / 4)
        
        self.addChild(dinosaur)
        self.addChild(landscape)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let setJumpTexture = SKAction.setTexture(GameScene.dinoTexture.textureNamed("jump.png"))
        let jumpUp = SKAction.moveBy(x: 0, y: 150, duration: 0.3)
        let jumpDown = SKAction.moveBy(x: 0, y: -150, duration: 0.3)
        
        dinosaur.run(SKAction.sequence([setJumpTexture, jumpUp, jumpDown])) {
            self.view?.presentScene(self.gameScene)
        }
    }
}
