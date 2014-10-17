//
//  Barriers.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/12/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "Barriers.h"

@implementation Barriers
static const uint32_t rightBarrierCategory = 0x1 << 1;
//static const uint32_t topBarrierCategory = 0x1 << 2;


// factory method to return top barrier
+(id)topBarrier
{
    // create top barrier and set properties
    Barriers *topBarrier = [Barriers spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(513, 30)];
    topBarrier.name = @"topBarrier";
    topBarrier.position = CGPointMake(0, 700);
    topBarrier.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:topBarrier.size];
    //topBarrier.physicsBody.categoryBitMask = topBarrierCategory;
    topBarrier.physicsBody.dynamic = NO;
    
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
    leftBarrier.physicsBody.dynamic = NO;
    
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
    rightBarrier.physicsBody.categoryBitMask = rightBarrierCategory;
    rightBarrier.physicsBody.dynamic = NO;
    
    return rightBarrier;
}

@end
