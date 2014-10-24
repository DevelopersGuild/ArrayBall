//
//  Barriers.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/12/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "Barriers.h"

@implementation Barriers
static const uint32_t barrierCategory = 0x1 << 1;

// factory method to return top barrier
+(id)topBarrier
{
    // create top barrier and set properties
    Barriers *topBarrier = [Barriers spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(513, 30)];
    topBarrier.name = @"topBarrier";
    topBarrier.position = CGPointMake(0, 700);
    topBarrier.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:topBarrier.size];
    topBarrier.physicsBody.categoryBitMask = barrierCategory;
    topBarrier.physicsBody.dynamic = NO;
    topBarrier.physicsBody.affectedByGravity = NO;
    
    return topBarrier;
}

// factory method to return left barrier
+(id)leftBarrier
{
    // create left barrier and set properties
    Barriers *leftBarrier = [Barriers spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(30, 850)];
    leftBarrier.name = @"leftBarrier";
    leftBarrier.position = CGPointMake(-225, 340);
    leftBarrier.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftBarrier.size];
    leftBarrier.physicsBody.categoryBitMask = barrierCategory;
    leftBarrier.physicsBody.dynamic = NO;
    leftBarrier.physicsBody.affectedByGravity = NO;
    
    return leftBarrier;
}

// factory method to return right barrier
+(id)rightBarrier
{
    // create right barrier and set properties
    Barriers *rightBarrier = [Barriers spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(30, 850)];
    rightBarrier.name = @"rightBarrier";
    rightBarrier.position = CGPointMake(225, 340);
    rightBarrier.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightBarrier.size];
    rightBarrier.physicsBody.categoryBitMask = barrierCategory;
    rightBarrier.physicsBody.dynamic = NO;
    rightBarrier.physicsBody.affectedByGravity = NO;
    
    return rightBarrier;
}

+(id)gameOverBarrier
{
    Barriers *gameOverBarrier = [Barriers spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(1000, 20)];
    gameOverBarrier.name = @"gameOverBarrier";
    gameOverBarrier.position = CGPointMake(0, -80);
    gameOverBarrier.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gameOverBarrier.size];
    gameOverBarrier.physicsBody.categoryBitMask = barrierCategory;
    gameOverBarrier.physicsBody.dynamic = NO;
    gameOverBarrier.physicsBody.affectedByGravity = NO;
    
    return gameOverBarrier;
}


@end
