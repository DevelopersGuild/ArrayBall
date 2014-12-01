//
//  MainMenuScene.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 11/23/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"
#import <AVFoundation/AVFoundation.h>

@interface MainMenuScene ()

@end

@implementation MainMenuScene

{
    AVAudioPlayer *menuMusic;
    
    NSMutableArray *mainSKNodes, *mainLabelNodes, *tempLabelNodes;
    
    SKLabelNode *arrayBallTitle;
}

-(void)didMoveToView:(SKView *)view
{
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    mainSKNodes = [[NSMutableArray alloc] init];
    mainLabelNodes = [[NSMutableArray alloc] init];
    tempLabelNodes = [[NSMutableArray alloc] init];
    
    arrayBallTitle = [SKLabelNode labelNodeWithText:@"Array Ball"];
    arrayBallTitle.fontColor = [UIColor purpleColor];
    arrayBallTitle.fontSize = 60;
    arrayBallTitle.position = CGPointMake(0, 220);
    [self addChild:arrayBallTitle];
    
    // DO NOT USE MAINSPACE.PNG
    SKSpriteNode *menuBackground = [SKSpriteNode spriteNodeWithImageNamed:@"TitleSpace"];
    menuBackground.size = CGSizeMake(1180, 800);
    [self addChild:menuBackground];
    [mainSKNodes addObject:menuBackground];
    
    SKLabelNode *playButton = [SKLabelNode labelNodeWithText:@"Begin Mission"];
    playButton.name = @"playButton";
    playButton.fontSize = 50;
    playButton.position = CGPointMake(0, -220);
    playButton.fontColor = [UIColor greenColor];
    [self addChild:playButton];
    [self animateWithPulse:playButton withAlpha:1];
    [mainLabelNodes addObject:playButton];
    
    SKLabelNode *optionsButton = [SKLabelNode labelNodeWithText:@"Options"];
    optionsButton.name = @"optionsButton";
    optionsButton.fontSize = 50;
    optionsButton.position = CGPointMake(0, 80);
    optionsButton.fontColor = [UIColor greenColor];
    [self addChild:optionsButton];
    [self animateWithPulse:optionsButton withAlpha:1];
    [mainLabelNodes addObject:optionsButton];
    
    SKLabelNode *howToPlayButton = [SKLabelNode labelNodeWithText:@"How to play"];
    howToPlayButton.name = @"howToPlayButton";
    howToPlayButton.fontSize = 50;
    howToPlayButton.position = CGPointMake(0, 150);
    howToPlayButton.fontColor = [UIColor greenColor];
    [self addChild:howToPlayButton];
    [self animateWithPulse:howToPlayButton withAlpha:1];
    [mainLabelNodes addObject:howToPlayButton];
    
    SKLabelNode *creditsButton = [SKLabelNode labelNodeWithText:@"Credits"];
    creditsButton.name = @"creditsButton";
    creditsButton.fontSize = 50;
    creditsButton.position = CGPointMake(0, 10);
    creditsButton.fontColor = [UIColor greenColor];
    [self addChild:creditsButton];
    [self animateWithPulse:creditsButton withAlpha:1];
    [mainLabelNodes addObject:creditsButton];
    
    NSURL *urlMusic = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MenuMusic" ofType:@"mp3"]];
    menuMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:urlMusic error:nil];
    [menuMusic play];
}

- (void)doVolumeFade
{
    if (menuMusic.volume > 0.1) {
       menuMusic.volume -= 0.1;
       [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.08];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"playButton"])
    {
        NSLog(@"play button pressed");
        [self removeAllActions];
        
        SKTransition *gameTransition = [SKTransition crossFadeWithDuration:3];
        SKScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:gameTransition];
        
        [self doVolumeFade];
    }
    
    else if ([node.name isEqualToString:@"howToPlayButton"])
    {
        NSLog(@"How to play button pressed");
        
        [self addInfoBox];
        
    }
    
    else if ([node.name isEqualToString:@"optionsButton"])
    {
        NSLog(@"Options button pressed");
        
        [self addInfoBox];
    }
    
    else if ([node.name isEqualToString:@"creditsButton"])
    {
        NSLog(@"Credits button pressed");
        
        SKLabelNode *madeByNode = [SKLabelNode labelNodeWithText:@"Programmed by Garrett Crawford"];
        [self addChild:madeByNode];
        madeByNode.fontSize = 25;
        [tempLabelNodes addObject:madeByNode];
        
        [self addInfoBox];
    }
    
    else if ([node.name isEqualToString:@"exitButton"])
    {
        NSLog(@"exit button pressed");
        
        for (SKSpriteNode *sk in mainSKNodes)
        {
            sk.alpha = 1.0;
        }
            
        for (SKLabelNode *ln in mainLabelNodes)
        {
            [self animateWithPulse:ln withAlpha:1.0];
        }
        
        [mainSKNodes.lastObject removeFromParent];
        [tempLabelNodes.lastObject removeFromParent];
        [tempLabelNodes removeAllObjects];
            
        arrayBallTitle.alpha = 1.0;
    }
}

-(void)addInfoBox
{
    arrayBallTitle.alpha = 0.0;
    
    for (SKSpriteNode *sk in mainSKNodes)
    {
        sk.alpha = 0.2;
    }
    
    for (SKLabelNode *ln in mainLabelNodes)
    {
        [self animateWithPulse:ln withAlpha:0.0];
    }
    
    SKSpriteNode *blackBox = [SKSpriteNode spriteNodeWithImageNamed:@"blackBox"];
    blackBox.size = CGSizeMake(400, 400);
    [self addChild:blackBox];
    blackBox.alpha = 0.7;
    [mainSKNodes addObject:blackBox];
    
    SKSpriteNode *exitButton = [SKSpriteNode spriteNodeWithImageNamed:@"exitButton"];
    exitButton.size = CGSizeMake(50, 50);
    [blackBox addChild:exitButton];
    exitButton.position = CGPointMake(-150, -150);
    exitButton.name = @"exitButton";
}


-(void)animateWithPulse:(SKNode *)node withAlpha:(float)alpha
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:1.0];
    SKAction *appear = [SKAction fadeAlphaTo:alpha duration:1.0];
    
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}



@end
