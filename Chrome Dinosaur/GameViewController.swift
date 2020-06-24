//
//  GameViewController.swift
//  Chrome Dinosaur
//
//  Created by 于兆良 on 2020/4/12.
//  Copyright © 2020 于兆良. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: StartScene!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        // skView.showsPhysics = true
        
        scene = StartScene(size: skView.frame.size)
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
    }
}
