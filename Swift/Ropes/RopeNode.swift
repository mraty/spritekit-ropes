//
//  RopeNode.swift
//  Ropes
//
//  Created by Luke Durrant on 22/09/2015.
//  Copyright © 2015 Bingy Bongy. All rights reserved.
//

import SpriteKit

class RopeNode: SKNode {
    
    
    private var ropeParts:NSMutableArray?
    
    private var attachedObject:SKSpriteNode?
    private var startNode:SKNode?
    private var positionOnStartNode:CGPoint?
    private var aRopeLength:NSInteger = 10
    
    
    func setAttachmentPoint(point: CGPoint, toNode aNode: SKNode)
    {
        self.positionOnStartNode = point
        self.startNode = aNode
    }
    
    func setAttachObject(object: SKSpriteNode)
    {
        self.attachedObject = object
    }
    
    func setRopeLength(length: NSInteger)
    {
        self.ropeParts = NSMutableArray.init(capacity: length)
        
        let firstPart = SKSpriteNode(imageNamed: "rope_ring")
        if let positionOnStartNode:CGPoint = self.positionOnStartNode
        {
            firstPart.position = positionOnStartNode
        }
        firstPart.physicsBody = SKPhysicsBody(circleOfRadius: firstPart.size.width)
        firstPart.physicsBody?.allowsRotation = true
        
        self.ropeParts?.addObject(firstPart)
        self.scene?.addChild(firstPart)
        
        for var index:NSInteger = 1; index < length; index++ {
            let ropePart: SKSpriteNode = SKSpriteNode(imageNamed: "rope_ring")

            let calY:CGFloat = (CGFloat(index) * ropePart.size.height)
            
            ropePart.position = CGPointMake(firstPart.position.x, firstPart.position.y - calY)
            ropePart.physicsBody = SKPhysicsBody(circleOfRadius: ropePart.size.width)
            ropePart.physicsBody?.allowsRotation = true

            self.scene?.addChild(ropePart)
            self.ropeParts?.addObject(ropePart)
        }
        
        if let object: SKSpriteNode = self.attachedObject
        {
            let previous:SKNode = self.ropeParts?.lastObject as! SKNode
            object.position = CGPointMake(previous.position.x, CGRectGetMaxY(previous.frame))
            object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.height/2)

            self.scene?.addChild(object)
            self.ropeParts?.addObject(object)
        }
        self.ropePhysics()
        
    }
    func ropeLength() -> NSInteger
    {
        if let ropeParts:NSMutableArray = self.ropeParts
        {
            return ropeParts.count
        }
        else
        {
            return 0
        }
    }
    func ropePhysics()
    {
        if let nodeA: SKNode = self.startNode
        {
            let nodeB: SKSpriteNode = (self.ropeParts?.objectAtIndex(0)) as! SKSpriteNode
            
            //let anchorPoint: CGPoint = CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame))
        
            let joint: SKPhysicsJointPin = SKPhysicsJointPin.jointWithBodyA(nodeA.physicsBody!, bodyB: nodeB.physicsBody!, anchor: self.positionOnStartNode!)
        
            self.scene?.physicsWorld.addJoint(joint)
        }
        
        //Now add the newly created SpriteNodes and loop throuhg them and attach the previous one with the other one with a Physics join and then add them to the phsyics world
        let itemCount:NSInteger = self.ropeLength()
        
        for var index:NSInteger = 1; index < itemCount; index++
        {
            let nodeA:SKSpriteNode = (self.ropeParts?.objectAtIndex(index-1)) as! SKSpriteNode
            let nodeB:SKSpriteNode = (self.ropeParts?.objectAtIndex(index)) as! SKSpriteNode

            let anchorPoint: CGPoint = CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame))
            
            let pinJoin: SKPhysicsJointPin = SKPhysicsJointPin.jointWithBodyA(nodeA.physicsBody!, bodyB: nodeB.physicsBody!, anchor: anchorPoint)
            
            self.scene?.physicsWorld .addJoint(pinJoin)
            
        }
    }
}
