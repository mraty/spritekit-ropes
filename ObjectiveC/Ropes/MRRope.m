//
//  MRRope.m
//  Ropes
//
//  Created by Matti Räty on 10.9.2013.  (Twitter: @matraty)
//

#import "MRRope.h"


@interface MRRope ()
{
    NSMutableArray *_ropeParts;
    SKSpriteNode *_attachedObject;
    SKNode *_startNode;
    CGPoint _positionOnStartNode;
}
@end

@implementation MRRope

-(void) setAttachmentPoint:(CGPoint) point toNode:(SKNode*) node {
    _positionOnStartNode = point;
    _startNode = node;
}

-(void) attachObject:(SKSpriteNode*) object {
    _attachedObject = object;
}


-(void) setRopeLength:(int) ropeLength {
    if (_ropeParts) {
        [_ropeParts removeAllObjects];
        _ropeParts = nil;
    }
    
    _ropeParts = [NSMutableArray arrayWithCapacity:ropeLength];
    
    SKSpriteNode *firstPart = [SKSpriteNode spriteNodeWithImageNamed:@"rope_ring"];
    firstPart.position = _positionOnStartNode;
    firstPart.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:firstPart.size.width];
    firstPart.physicsBody.allowsRotation = YES;
    
    [_ropeParts addObject:firstPart];
    [self.scene addChild:firstPart];
    
    for (int i=1; i<ropeLength; i++) {
        SKSpriteNode *ropePart = [SKSpriteNode spriteNodeWithImageNamed:@"rope_ring"];
        ropePart.position = CGPointMake(firstPart.position.x, firstPart.position.y - (i*ropePart.size.height));
        ropePart.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ropePart.size.width];
        ropePart.physicsBody.allowsRotation = YES;
        
        [self.scene addChild:ropePart];
        [_ropeParts addObject:ropePart];
    }
    
    if (_attachedObject) {
        SKSpriteNode *object =  _attachedObject;
        SKNode *previous = [_ropeParts lastObject];
        object.position = CGPointMake(previous.position.x, CGRectGetMaxY(previous.frame));
        object.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:object.size.height/2];
        
        [self.scene addChild:object];
        [_ropeParts addObject:object];
    }
    
    [self ropePhysics];
}

-(int) ropeLength {
    return _ropeParts.count;
}

-(void) ropePhysics {
    
    // Attach first node to start.
    
    SKNode *nodeA = _startNode;
    SKSpriteNode *nodeB = [_ropeParts objectAtIndex:0];
    
    SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA: nodeA.physicsBody
                                                           bodyB: nodeB.physicsBody
                                                          anchor: _positionOnStartNode];
    
    [self.scene.physicsWorld addJoint:joint];
    
    // Then add rest of the nodes and joints.
    
    for (int i=1; i<_ropeParts.count; i++) {
        SKSpriteNode *nodeA = [_ropeParts objectAtIndex:i-1];
        SKSpriteNode *nodeB = [_ropeParts objectAtIndex:i];
        SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA: nodeA.physicsBody
                                                               bodyB: nodeB.physicsBody
                                                              anchor: CGPointMake(CGRectGetMidX(nodeA.frame),
                                                                                  CGRectGetMinY(nodeA.frame))];
        
        [self.scene.physicsWorld addJoint:joint];
    }
}

@end
