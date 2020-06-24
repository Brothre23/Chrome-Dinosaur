//
//  GameScene.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/4/12.
//  Copyright © 2020 于兆良. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static let dinoTexture:SKTextureAtlas = SKTextureAtlas(named: "dinosaur")
    var landscape:SKSpriteNode!
    var dinosaur:SKSpriteNode!
    
    var jumpPlayer: AVAudioPlayer!
    var deadPlayer: AVAudioPlayer!
    var reachPlayer: AVAudioPlayer!
    
    var tapRecognizer: UITapGestureRecognizer!
    var swipeUpRecognizer: UISwipeGestureRecognizer!
    var swipeDownRecognizer: UISwipeGestureRecognizer!
    
    var moveSpeed: CGFloat!
    var enemyType: Bool!
    var lastTouchTime: CFTimeInterval!
    var lastEnemyTime: CFTimeInterval!
    var lastCloudTime: CFTimeInterval!
    var lastScoreUpdateTime: CFTimeInterval!
    var enemyWaitTime: Double!
    var currentWalkingMode: WalkingMode!
    
    static let characterCategory: UInt32 = 0x1 << 0
    static let flyingEnemyCategory: UInt32 = 0x1 << 1
    static let landEnemyCategory: UInt32 = 0x1 << 2
    
    var currentScore: Int!
    var highScore: Int!
    
    var userDefault: UserDefaults!
    var score: Score!
    
    var normalWalkForever:SKAction!
    var downWalkForever:SKAction!
    
    var backgroundNode: SKSpriteNode!
    var currentColor: BackgroundColor!
    var colorChanging: Bool!
    var changeToGray: SKAction!
    var changeToWhite: SKAction!
    
    func setupDinosaur() {
        let normalWalkOnce = SKAction.animate(with: [GameScene.dinoTexture.textureNamed("normal_1.png"), GameScene.dinoTexture.textureNamed("normal_2.png")], timePerFrame: 0.1, resize: true, restore: false)
        normalWalkForever = SKAction.repeatForever(normalWalkOnce)

        let downWalkOnce = SKAction.animate(with: [GameScene.dinoTexture.textureNamed("down_1.png"), GameScene.dinoTexture.textureNamed("down_2.png")], timePerFrame: 0.1, resize: true, restore: false)
        downWalkForever = SKAction.repeatForever(downWalkOnce)
        
        dinosaur = SKSpriteNode(texture: GameScene.dinoTexture.textureNamed("normal_1.png"))
        dinosaur.name = "dinosaur"
        dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2, name: "normal_1")
        dinosaur.zPosition = 15
        
        dinosaur.run(normalWalkForever)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.physicsWorld.contactDelegate = self
        
        do {
            jumpPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "jump", withExtension: "mp3", subdirectory: "bgm")!)
            deadPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "dead", withExtension: "mp3", subdirectory: "bgm")!)
            reachPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "reach", withExtension: "mp3", subdirectory: "bgm")!)
        } catch {
            print(error.localizedDescription)
        }
        
        moveSpeed = 10
        lastTouchTime = 0
        lastEnemyTime = 0
        lastCloudTime = 0
        lastScoreUpdateTime = CACurrentMediaTime()
        currentScore = 0
        currentWalkingMode = .normal
        
        currentColor = .white
        backgroundNode = SKSpriteNode(color: UIColor.white, size: CGSize(width: self.size.width * 2, height: self.size.height * 2))
        colorChanging = false
        changeToGray = SKAction.colorize(with: UIColor.gray, colorBlendFactor: 1.0, duration: 0.5)
        changeToWhite = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 0.5)
        
        userDefault = UserDefaults()
        highScore = userDefault.integer(forKey: "high score")
        score = Score(parentScene: self)
    }
    
    override func didMove(to view: SKView) {
        for i in 0...1 {
            landscape = SKSpriteNode(imageNamed: "landscape")
            landscape.name = "landscape"
            landscape.position = CGPoint(x: CGFloat(i) * landscape.size.width, y: landscape.size.height * 0.5)
            
            self.addChild(landscape)
        }
        
        setupDinosaur()
        self.addChild(dinosaur)
        
        score.updateHighScore()
        
        self.addChild(backgroundNode)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.tapHandler(recognizer:)))
        view.addGestureRecognizer(tapRecognizer)
        
        swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeUpHandler(recognizer:)))
        swipeUpRecognizer.direction = .up
        view.addGestureRecognizer(swipeUpRecognizer)
        
        swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeDownHandler(recognizer:)))
        swipeDownRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownRecognizer)
        
        isPaused = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        enemyWaitTime = Double.random(in: 1...3)
        if currentTime - lastEnemyTime > enemyWaitTime {

            var enemy:SKSpriteNode!
            enemyType = Bool.random()

            if self.enemyType {
                enemy = Enemy("cactus")
                enemy.position = CGPoint(x: self.size.width + enemy.size.width / 2, y: landscape.size.height / 4 + enemy.size.height / 2)
            }
            else {
                enemy = Enemy("bird")
                let yPosition = CGFloat.random(in: landscape.size.height + enemy.size.height / 2...self.size.height / 2 - enemy.size.height / 2)
                enemy.position = CGPoint(x: self.size.width + enemy.size.width / 2, y: yPosition)
            }
            
            self.addChild(enemy)

            lastEnemyTime = currentTime
        }
        
        if currentTime - lastCloudTime > 5 {
            let cloud = SKSpriteNode(imageNamed: "cloud")
            let yPosition = CGFloat.random(in: self.size.height / 2 + cloud.size.height / 2...self.size.height - cloud.size.height / 2)
            cloud.position = CGPoint(x: self.size.width + cloud.size.width / 2, y: yPosition)
            cloud.zPosition = 5
            
            cloud.name = "cloud"
            self.addChild(cloud)
            
            lastCloudTime = currentTime
        }
        
        if currentTime - lastScoreUpdateTime > 0.1 {
            currentScore += 10
            if !score.scoreFlashing {
                score.updateScore()
            }
            moveSpeed += 0.02
            lastScoreUpdateTime = currentTime
        }
        
        if !score.scoreFlashing && currentScore > 0 && currentScore.isMultiple(of: 500) {
            reachPlayer.play()
            score.scoreFlashing.toggle()
            score.flash()
        }
        
        if !colorChanging && currentScore > 0 && currentScore.isMultiple(of: 1000) {
            colorChanging.toggle()
            switch currentColor {
            case .white:
                currentColor = .gray
                backgroundNode.run(changeToGray) {
                    self.colorChanging.toggle()
                }
            case .gray:
                currentColor = .white
                backgroundNode.run(changeToWhite) {
                    self.colorChanging.toggle()
                }
            default:
                break
            }
        }
        
        self.enumerateChildNodes(withName: "landscape") {
            (node, _) in
            
            let newLandscape = node as! SKSpriteNode
            newLandscape.position.x -= self.moveSpeed
           
            if newLandscape.position.x <= -newLandscape.size.width {
                newLandscape.position.x += newLandscape.size.width * 2
            }
        }
        
        self.enumerateChildNodes(withName: "enemy") {
            (node, _) in
            
            let enemy = node as! SKSpriteNode
            enemy.position.x -= self.moveSpeed
         
            if enemy.position.x <= -enemy.size.width / 2 {
                enemy.removeFromParent()
            }
        }
        
        self.enumerateChildNodes(withName: "cloud") {
            (node, _) in
            
            let cloud = node as! SKSpriteNode
            cloud.position.x -= self.moveSpeed / 2
            
            if cloud.position.x <= -cloud.size.width / 2 {
                cloud.removeFromParent()
            }
        }
    }
    
    @objc func tapHandler(recognizer: UITapGestureRecognizer){

        if !isPaused {
            if CACurrentMediaTime() - lastTouchTime < 0.6 || currentWalkingMode != .normal {
                return
            }
            
            jumpPlayer.play()
            
            lastTouchTime = CACurrentMediaTime()
            
            let setJumpTexture = SKAction.setTexture(GameScene.dinoTexture.textureNamed("jump.png"))
            let setWalkTexture = SKAction.setTexture(GameScene.dinoTexture.textureNamed("normal_2.png"))
            let jumpUp = SKAction.moveBy(x: 0, y: 150, duration: 0.3)
            let jumpDown = SKAction.moveBy(x: 0, y: -150, duration: 0.3)
            
            dinosaur.removeAllActions()
            dinosaur.run(SKAction.sequence([setJumpTexture, jumpUp, jumpDown, setWalkTexture])) {
                self.dinosaur.run(self.normalWalkForever)
            }
        }
        else {
            let positionInScene = convertPoint(fromView: recognizer.location(in: view))
            let touchedNode = self.nodes(at: positionInScene)
            
            if !touchedNode.isEmpty && touchedNode[0].name == "GG"
            {
                self.enumerateChildNodes(withName: "GG") {
                    (node, _) in
                    node.removeFromParent()
                }
                
                self.enumerateChildNodes(withName: "enemy") {
                    (node, _) in
                    node.removeFromParent()
                }
                
                currentWalkingMode = .normal
                
                currentScore = 0
                score.updateHighScore()
                score.reset()
                
                lastScoreUpdateTime = CACurrentMediaTime()
                moveSpeed = 10
                
                dinosaur.position = CGPoint(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2)
                dinosaur.run(normalWalkForever)
                
                if currentColor == .gray {
                    backgroundNode.run(changeToWhite)
                    currentColor = .white
                }
                
                self.isPaused.toggle()
            }
            else {
                return
            }
        }
    }
    
    @objc func swipeUpHandler(recognizer: UISwipeGestureRecognizer) {
        
        if currentWalkingMode != .down {
            return
        }

        dinosaur.removeAllActions()
        dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + GameScene.dinoTexture.textureNamed("normal_1").size().height / 2, name: "normal_1")
        dinosaur.run(normalWalkForever)
        currentWalkingMode = .normal
    }

    @objc func swipeDownHandler(recognizer: UISwipeGestureRecognizer){
        
        if currentWalkingMode != .normal {
            return
        }
        
        dinosaur.removeAllActions()
        dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + GameScene.dinoTexture.textureNamed("down_1").size().height / 2, name: "down_1")
        dinosaur.run(downWalkForever)
        currentWalkingMode = .down
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        deadPlayer.play()
        
        let gameOverLabel = SKSpriteNode(imageNamed: "GG.png")
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverLabel.name = "GG"
        let restartLabel = SKSpriteNode(imageNamed: "restart.png")
        restartLabel.position = CGPoint(x: self.size.width / 2, y: gameOverLabel.position.y - 100)
        restartLabel.name = "GG"
        
        dinosaur.removeAllActions()
        dinosaur.texture = GameScene.dinoTexture.textureNamed("died.png")
        dinosaur.size = CGSize(width: GameScene.dinoTexture.textureNamed("died.png").size().width, height: GameScene.dinoTexture.textureNamed("died.png").size().height)
        
        switch currentWalkingMode {
        case .down:
            dinosaur.setPhysics(x: 100, y: landscape.size.height / 4 + dinosaur.size.height / 2, name: "died")
        case .normal:
            dinosaur.setPhysics(x: dinosaur.position.x, y: dinosaur.position.y, name: "died")
        default:
            break
        }

        self.addChild(gameOverLabel)
        self.addChild(restartLabel)
        
        if currentScore > highScore {
            highScore = currentScore
            userDefault.set(highScore, forKey: "high score")
        }
        
        self.isPaused.toggle()
    }
}
