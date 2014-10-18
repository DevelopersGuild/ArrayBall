//
//  Sounds.h
//  Dogs in space
//
//  Created by Kartuzov Maxim on 28.09.14.
//  Copyright (c) 2014 Sputnik Labs. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface Sounds : NSObject
{
    SystemSoundID SoundId;
}
@property (nonatomic) SystemSoundID SoundId;

-(void)playPaddleSound;
-(void)playBarrierSound;

@end