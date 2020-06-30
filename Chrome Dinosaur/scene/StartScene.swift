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
    static let marioTexture: SKTextureAtlas = SKTextureAtlas(named: "mario")
    var landscape: SKSpriteNode!
    var dinosaur: SKSpriteNode!
    var mario: SKSpriteNode!
    
    var changeSceneDelegate: ChangeSceneDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = UIColor.white
        
        dinosaur = SKSpriteNode(texture: StartScene.dinoTexture.textureNamed("dinosaur_died.png"))
        dinosaur.name = "dinosaur"
        
        mario = SKSpriteNode(texture: StartScene.marioTexture.textureNamed("mario_died.png"))
        mario.name = "mario"
        
        landscape = SKSpriteNode(imageNamed: "landscape")
    }
    
    override func didMove(to view: SKView) {
        
        dinosaur.position = CGPoint(x: 100, y: dinosaur.size.height / 2 + landscape.size.height / 4)
        mario.position = CGPoint(x: 200, y: mario.size.height / 2 + landscape.size.height / 4)
        landscape.position = CGPoint(x: self.size.width / 2, y: landscape.size.height * 0.5)
        
        self.addChild(dinosaur)
        self.addChild(mario)
        self.addChild(landscape)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.nodes(at: positionInScene)
        
        if !touchedNode.isEmpty {
            
            switch touchedNode[0].name {
            case "dinosaur":
                let setJumpTexture = SKAction.setTexture(StartScene.dinoTexture.textureNamed("dinosaur_jump.png"))
                let jumpUp = SKAction.moveBy(x: 0, y: 150, duration: 0.3)
                let jumpDown = SKAction.moveBy(x: 0, y: -150, duration: 0.3)
                
                dinosaur.run(SKAction.sequence([setJumpTexture, jumpUp, jumpDown])) {
                    self.changeSceneDelegate?.changeToGameScene(self.size, "dinosaur")
                }
            case "mario":
                let setJumpTexture = SKAction.setTexture(StartScene.marioTexture.textureNamed("mario_jump.png"))
                let jumpUp = SKAction.moveBy(x: 0, y: 150, duration: 0.3)
                let jumpDown = SKAction.moveBy(x: 0, y: -150, duration: 0.3)
                
                mario.run(SKAction.sequence([setJumpTexture, jumpUp, jumpDown])) {
                    self.changeSceneDelegate?.changeToGameScene(self.size, "mario")
                }
            default:
                break
            }
            
        }
        
    }
}
