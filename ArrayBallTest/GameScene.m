//
//  GameScene.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/7/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "GameScene.h"
#import "Paddle.h"
#import "Ball.h"
#import "Barriers.h"

// set up property to hold the speed of the ball here

@interface GameScene ()
// this checks to see if the game has started
@property BOOL isStarted;
// this checks if the user is touching
@property BOOL isTouching;
// this checks if the paddle is moving left
@property BOOL movingLeft;
// this checks if the paddle is moving right
@property BOOL movingRight;
@end

@implementation GameScene
{
    // set our paddle to be global
    Paddle *paddle;
    
    // set up a node tree to hold our all of our nodes
    SKNode *scene;
    
    // set our ball to be global
    Ball *ball;
    
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    // set up our node tree
    scene = [SKNode node];
    [self addChild:scene];
    
    // set the background color to white
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    // set anchor point to be in the middle toward the bottom of the screen
    self.anchorPoint = CGPointMake(0.5, 0.1);
    
    // contactDelegate is a protocol
    self.physicsWorld.contactDelegate = self;
    
    // create our paddle and add it to the scene (node tree)
    paddle = [Paddle paddle];
    [scene addChild:paddle];
    
    // create our ball and add it to the scene
    ball = [Ball ball];
    [scene addChild:ball];
    
    // create our barriers
    Barriers *topBarrier = [Barriers topBarrier];
    Barriers *leftBarrier = [Barriers leftBarrier];
    Barriers *rightBarrier = [Barriers rightBarrier];
    
    // add them to the scene
    [scene addChild:topBarrier];
    [scene addChild:leftBarrier];
    [scene addChild:rightBarrier];
    
    // add the buttons to the scene
    [scene addChild:[self leftButton]];
    [scene addChild:[self rightButton]];
}

// this creates the button that moves our paddle left
-(SKSpriteNode *)leftButton
{
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(60, 60)];
    leftButton.name = @"leftButton";
    leftButton.position = CGPointMake(-180, -50);
    
    return leftButton;
}

// this creates the button to move the paddle right
-(SKSpriteNode *)rightButton
{
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(60, 60)];
    rightButton.name = @"rightButton";
    rightButton.position = CGPointMake(180, -50);
    
    return rightButton;
}

-(void)start
{
    self.isStarted = YES;
    [ball move:5 withDeltaY:10];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // this starts the movement of the ball
    if (!self.isStarted) {
        [self start];
    }
    
    // this block is executed if the game has already started
    else {
        self.isTouching = YES;
        
        // create a touch object to look for touch
        UITouch *touch = [touches anyObject];
        
        // finds the location of a touch
        CGPoint location = [touch locationInNode:scene];
        
        SKNode *node = [self nodeAtPoint:location];
    
        // if the user touches the left button, move the paddle left
        if ([node.name isEqualToString:@"leftButton"]) {
            self.movingLeft = YES;
            [paddle movePaddleLeft:-8];
        }
        
        // if the user touches the right button, move the paddle right
        else if ([node.name isEqualToString:@"rightButton"]) {
            self.movingRight = YES;
            [paddle movePaddleRight:8];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.isTouching = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:scene];
    SKNode *node = [self nodeAtPoint:location];
    
    // if the user lets go of the left button, stop paddle movement
    if ([node.name isEqualToString:@"leftButton"]) {
        self.movingLeft = NO;
        [paddle stopMoving];
    }
    
    // if the user lets go of the right button, stop paddle movement
    else if ([node.name isEqualToString:@"rightButton"]) {
        self.movingRight = NO;
        [paddle stopMoving];
    }
}

// see comment below
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (self.isTouching && self.movingLeft) {
        [paddle movePaddleLeft:-8];
    }
    
    else if (self.isTouching && self.movingRight) {
        [paddle movePaddleRight:8];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    // if the ball makes contact with the right barrier
    // move the ball to the left
    if ([contact.bodyA.node.name isEqualToString:@"rightBarrier"] || [contact.bodyB.node.name isEqualToString:@"rightBarrier"]) {
        [ball move:-15 withDeltaY:0];
        // comment test
   }
    
    // if the ball makes contact with the left barrier
    // move the ball to the right
    else if ([contact.bodyA.node.name isEqualToString:@"leftBarrier"] || [contact.bodyB.node.name isEqualToString:@"leftBarrier"]) {
        [ball move:15 withDeltaY:0];
    }
    
    // if the ball makes contact with the top barrier
    // move the ball down
    else if ([contact.bodyA.node.name isEqualToString:@"topBarrier"] || [contact.bodyB.node.name isEqualToString:@"topBarrier"]) {
        [ball move:0 withDeltaY:-20];
    }
   
    // if the ball makes contact with the paddle
    // move the ball up and change the color of the paddle
    else if ([contact.bodyA.node.name isEqualToString:@"ball"] || [contact.bodyB.node.name isEqualToString:@"ball"]) {
        [paddle setColor:[paddle getRandomColor]];
        [ball move:0 withDeltaY:20];
    }
    
}

@end
