//
//  MRRope.h
//  Ropes
//
//  Created by Matti Räty on 10.9.2013. (Twitter: @matraty)
//

#import <SpriteKit/SpriteKit.h>

@interface MRRope : SKNode

@property int ropeLength;

// Attach rope to SKNode.
-(void) setAttachmentPoint:(CGPoint) point toNode:(SKNode*) body;

// Set set something to hang on the end of the rope.
-(void) attachObject:(SKSpriteNode*) object;

@end
