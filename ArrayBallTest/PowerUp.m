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
    PowerUp *powerUp = [PowerUp spriteNodeWithImageNamed:@"powerup"];
    
    powerUp.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:powerUp.size];
    
    return powerUp;
}

@end
