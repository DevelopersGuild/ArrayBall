//
//  Paddle.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/7/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "Paddle.h"

@implementation Paddle
static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t paddleCategory = 0x1 << 2;

// factory method to return our paddle
+(id)paddle
{
    // create a black rectangle to represent our paddle
    Paddle *paddle = [Paddle spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(90, 15)];
    
    // set paddle name property
    paddle.name = @"paddle";
    
    // give our paddle a physics body
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
    
    // sets the mass of the paddle to a high value so that the ball
    // does not push it down
    paddle.physicsBody.mass = 5000000;
    
    // allows our paddle to not be affected by rotational forces from barriers
    paddle.physicsBody.allowsRotation = NO;
    
    paddle.physicsBody.categoryBitMask = paddleCategory;
    paddle.physicsBody.contactTestBitMask = ballCategory;
    
    // 'disable' gravity on the paddle so that it does not fall straight down off the screen
    // read more about 'dynamic' in API
    paddle.physicsBody.dynamic = YES;
    paddle.physicsBody.affectedByGravity = NO;
    
    return paddle;
}

// this method will move our paddle to the left
-(void)movePaddleLeft:(int)speed
{
    self.paddleLeftMovementSpeed = speed;
    
    SKAction *moveLeft = [SKAction moveByX:self.paddleLeftMovementSpeed y:0 duration:0.1];
    
    [self runAction:moveLeft];
    
}

// this method moves the paddle to the right
-(void)movePaddleRight:(int)speed
{
    self.paddleRightMovementSpeed = speed;
    
    SKAction *moveRight = [SKAction moveByX:self.paddleRightMovementSpeed y:0 duration:0.1];
    
    [self runAction:moveRight];
}

-(void)stopMoving
{
    // NSLog(@"stopped");
}

@end
