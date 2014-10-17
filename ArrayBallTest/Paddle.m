//
//  Paddle.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/7/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "Paddle.h"

@implementation Paddle

// factory method to return our paddle
+(id)paddle
{
    // create a black rectangle to represent our paddle
    Paddle *paddle = [Paddle spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(90, 15)];
    
    // set paddle name property
    paddle.name = @"paddle";
    
    // give our paddle a physics body
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
    
    // 'disable' gravity on the paddle so that it does not fall straight down off the screen
    paddle.physicsBody.dynamic = NO;
    
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
