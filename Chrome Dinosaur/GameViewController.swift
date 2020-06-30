//
//  GameViewController.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/4/12.
//  Copyright © 2020 于兆良. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, ChangeSceneDelegate {
    
    var skView: SKView!
    
    func changeToGameScene(_ size: CGSize, _ characterType: String) {
        let scene = GameScene(size, characterType)
        scene.scaleMode = .aspectFit
        scene.changeSceneDelegate = self
        skView.presentScene(scene)
    }
    
    func changeToStartScene(_ size: CGSize) {
        let scene = StartScene(size: size)
        scene.scaleMode = .aspectFit
        scene.changeSceneDelegate = self
        skView.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 1))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        skView = (view as! SKView)
        skView.ignoresSiblingOrder = true
        // skView.showsFPS = true
        // skView.showsNodeCount = true
        // skView.showsPhysics = true
        
        let scene = StartScene(size: skView.frame.size)
        scene.scaleMode = .aspectFill
        scene.changeSceneDelegate = self
        skView.presentScene(scene)
    }
}
