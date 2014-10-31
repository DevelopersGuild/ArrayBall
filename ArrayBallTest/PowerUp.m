//
//  PowerUp.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/31/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "PowerUp.h"

@implementation PowerUp

+(id)powerUp
{
    PowerUp *powerUp = [PowerUp spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(50, 50)];
    
    powerUp.position = CGPointMake(arc4random() % 400 + 1, 300);
    
    powerUp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:powerUp.size];
    
    powerUp.physicsBody.dynamic = NO;
    
    return powerUp;
}

@end
