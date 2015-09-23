//
//  GameScene.swift
//  Ropes
//
//  Created by Luke Durrant (@durrantluke) on 22/09/2015.
//  Copyright (c) 2015 Bingy Bongy. All rights reserved.
//

import SpriteKit

class RopeGameScene: SKScene {
    
    var touchMoving: Bool = false

    var touchStartPoint: CGPoint?
    var touchEndPoint: CGPoint?
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor(red: 0.2, green: 0.5, blue: 0.6, alpha: 1.0)
        self.buildScene()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildScene()
    {
        let edge: SKNode = SKNode()
        edge.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.addChild(edge)
        
        let branch: SKSpriteNode = SKSpriteNode.init(imageNamed: "Branch")
        branch.position = CGPointMake(CGRectGetMaxX(self.frame) - branch.size.width / 2, (CGRectGetMidY(self.frame)*2 ) - branch.size.height)
        
        branch.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(branch.frame.size.width, 10))
        
        let ropeAttachPos: CGPoint = CGPointMake(branch.position.x - 60, branch.position.y - 20)
        branch.physicsBody?.dynamic = false;
        branch.zPosition = 100
        
        self.addChild(branch)
        
        // All objects need to be initialized first. Position of attached object
        // is decided by rope and rope adds object to scene.
    
        let ball: SKSpriteNode = SKSpriteNode(imageNamed: "Ball")
        ball.name = "BALL"
        
        let rope:RopeNode = RopeNode.init()
        self.addChild(rope)
        
        rope.setAttachmentPoint(ropeAttachPos, toNode: branch)
        rope.setAttachObject(ball)
        
        rope.setRopeLength(40)
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            if(touches.count == 2)
            {
                let ball:SKNode = self.childNodeWithName("BALL") as SKNode!
                
                ball.physicsBody?.applyImpulse(CGVectorMake(10, 0))
                
            }
            else
            {
                let location = touch.locationInNode(self)
                touchStartPoint = location
            }
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
            if(touches.count == 1)
            {
                self.touchMoving = true
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if(touches.count == 1 && self.touchMoving == true)
            {
                let location = touch.locationInNode(self)
                self.touchEndPoint = location
                
                if((self.touchStartPoint?.x != self.touchEndPoint?.x) && (self.touchStartPoint?.y != self.touchEndPoint?.y))
                {
                    print("Do rope cutting")
                    
                    if let body:SKPhysicsBody = self.physicsWorld.bodyAlongRayStart(self.touchStartPoint!, end:self.touchEndPoint!)
                    {

                        if let joint: SKPhysicsJoint = body.joints.first
                        {
                            self.physicsWorld.removeJoint(joint)
                        }

                        
                        
                    }
                    
                    
                }
            }
        }
        self.touchMoving = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func resetScene()
    {
        self.removeAllActions()
        self.physicsWorld.removeAllJoints()
        self.removeAllChildren()

        self.buildScene()
    }
}
