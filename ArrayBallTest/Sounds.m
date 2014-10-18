
#import "Sounds.h"
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation Sounds

@synthesize SoundId;

-(void)playPaddleSound
{
    NSURL *buttonUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"b2" ofType:@"wav"]];
    
    // dafuq ?
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)buttonUrl, &SoundId);
    
    AudioServicesPlaySystemSound(SoundId);
}

-(void)playBarrierSound
{
    NSURL *buttonUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"b1" ofType:@"wav"]];
    
    // dafuq ?
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)buttonUrl, &SoundId);
    
    AudioServicesPlaySystemSound(SoundId);
}


@end