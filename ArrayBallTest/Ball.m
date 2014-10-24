//
//  Ball.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/10/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "Ball.h"
#import "Barriers.h"

@interface Ball ()

@property SKNode *world;

@end

@implementation Ball

// set up categories
static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t barrierCategory = 0x1 << 1;

// return our ball
+(id)ball
{
    // the ball is a random image from google
    Ball *ball = [Ball spriteNodeWithImageNamed:@"ball"];
    
    // set the position of the ball
    ball.position = CGPointMake(0, 80);
    
    // set ball name property
    ball.name = @"ball";
    
    // give the ball a physics body
    ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.size];

    // set up categoryBitMask for collision detection
    ball.physicsBody.categoryBitMask = ballCategory;
    
    // allows ball to make contact with barriers
    ball.physicsBody.contactTestBitMask = barrierCategory;
    
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

-(void)stopMoving
{
    [self removeAllActions];
}

@end
