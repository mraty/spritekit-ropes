//
//  MRMyScene.m
//  Ropes
//
//  Created by Matti Räty on 10.9.2013. (Twitter: @matraty)
//

#import "MRMyScene.h"
#import "MRRope.h"

@implementation MRMyScene {
    CGPoint _touchStartPoint;
    CGPoint _touchEndPoint;
    BOOL _touchMoving;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.2 green:0.5 blue:0.6 alpha:1.0];
        
        [self buildScene];
        
        _touchMoving = NO;
    }
    return self;
}

-(void) buildScene {
    
    SKNode *edge = [SKNode new];
    edge.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    [self addChild:edge];
    
    SKSpriteNode *branch = [SKSpriteNode spriteNodeWithImageNamed:@"Branch"];
    branch.position = CGPointMake(CGRectGetMaxX(self.frame) - branch.size.width / 2,
                                  CGRectGetMidY(self.frame) + 250);
    branch.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(branch.frame.size.width, 10)];
    CGPoint ropeAttachPos = CGPointMake(branch.position.x - 60, branch.position.y - 20 );
    branch.physicsBody.dynamic = NO;
    branch.zPosition = 100;
    
    [self addChild:branch];
    
    // All objects need to be initialized first. Position of attached object
    // is decided by rope and rope adds object to scene.
    
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
    ball.name = @"BALL";
    
    MRRope *rope = [MRRope new];
    [self addChild:rope];
    
    // Attach rope to branch.
    [rope setAttachmentPoint:ropeAttachPos toNode:branch];
    
    // This now actually creates physics body. Not ideal but good for the demo.
    [rope attachObject:ball];
    
    // Setting lenght actually also builds the rope. For production, have own method for building rope.
    rope.ropeLength = 40;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*_touchMoving = NO;
    
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        if (touches.count == 2) {
            SKNode *ball = [self childNodeWithName:@"BALL"];
            [ball.physicsBody applyImpulse:CGVectorMake(10, 0)];
        }
        else {
            _touchStartPoint = [touch locationInNode:self];
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch ends */
    for (UITouch *touch in touches) {

        if (touches.count == 1 && _touchMoving) {
            
            _touchEndPoint = [touch locationInNode:self];
            
            // Make sure we don't get 0 length raycast
            if ( (_touchStartPoint.x != _touchEndPoint.x) &&
                 (_touchStartPoint.y != _touchEndPoint.y) ) {
                
                NSLog(@"Do rope cutting");
                
                SKPhysicsBody *body = [self.physicsWorld bodyAlongRayStart:_touchStartPoint end:_touchEndPoint];
                
                if (body) {
                    NSLog(@"Hit body: %@", body);
                    
                    SKPhysicsJoint *joint = [[body joints] objectAtIndex:0];
                    [self.physicsWorld removeJoint:joint];
                }
            }
            
        }
    }
    
    _touchMoving = NO;
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (touches.count == 1) {
        for (UITouch *touch in touches) {
            
            NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"Sparky" ofType:@"sks"];
            SKEmitterNode *sparky = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
            sparky.position = [touch locationInNode:self];
            sparky.name = @"PARTICLE";
            [self addChild:sparky];
            
            _touchMoving = YES;
        }

    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void) resetScene {
    [self removeAllActions];
    [self.physicsWorld removeAllJoints];
    [self removeAllChildren];
    
    [self buildScene];
     
}

@end
