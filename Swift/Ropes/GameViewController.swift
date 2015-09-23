//
//  GameViewController.swift
//  Ropes
//
//  Created by Luke Durrant (@durrantluke) on 22/09/2015.
//  Copyright (c) 2015 Bingy Bongy. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    private var scene: RopeGameScene?
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true

        /* Sprite Kit applies additional optimizations to improve rendering performance */
        //skView.ignoresSiblingOrder = true
        
        scene = RopeGameScene(size: skView.bounds.size)
        
        /* Set the scale mode to scale to fit the window */
        scene?.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .AllButUpsideDown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func longTouchDetected(sender: AnyObject) {
        //Reset scene in here
        self.scene?.resetScene()
    }
}
