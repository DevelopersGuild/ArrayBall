//
//  GameScene.h
//  ArrayBallTest
//

//  Copyright (c) 2014 Noox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

// set our protocol with our gamescene
@interface GameScene : SKScene <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>
+(instancetype)unarchiveFromFile:(NSString *)file;
@end
