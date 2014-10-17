//
//  Ball.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/10/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "Ball.h"
#import "Barriers.h"

@implementation Ball

// set up categories
static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t rightBarrierCategory = 0x1 << 1;
//static const uint32_t topBarrierCategory = 0x1 << 2;

// return our ball
+(id)ball
{
    // the ball will be a square for now
    Ball *ball = [Ball spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
    
    // set the position of the ball
    ball.position = CGPointMake(0, 30);
    
    // set ball name property
    ball.name = @"ball";
    
    // give the ball a physics body
    ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.size];

    // set up categoryBitMask for collision detection
    ball.physicsBody.categoryBitMask = ballCategory;
    
    ball.physicsBody.contactTestBitMask = rightBarrierCategory;
    
    // this literally makes the ball unaffected by gravity
    ball.physicsBody.affectedByGravity = NO;
    
    return ball;
}

// this will animate the movement of the ball
-(void)move:(int)deltaX withDeltaY:(int)deltaY
{
    SKAction *testMoveRight = [SKAction moveByX:deltaX y:deltaY duration:0.03];
    
    // this will repeat the action over and over
    SKAction *move = [SKAction repeatActionForever:testMoveRight];
    [self runAction:move];
    
}

@end
