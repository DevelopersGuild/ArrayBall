//
//  GameScene.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/7/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//
//

#import "GameScene.h"
#import "Paddle.h"
#import "Ball.h"
#import "Barriers.h"
#import "PointsLabel.h"
#import "PowerUp.h"

// this gets us access to the AVAudioPlayer class
// which we use to play the game music
#import <AVFoundation/AVFoundation.h>

// set up property to hold the speed of the ball here

@interface GameScene ()
// this checks to see if the game has started
@property BOOL isStarted;
// checks to see if the game is over
@property BOOL isGameOver;

@property SKAction *gameMusic;

// checks to see how many balls are present
@property int ballCounter;

// this checks if the user is touching
@property BOOL isTouching;
// this checks if the paddle is moving left
@property BOOL movingLeft;
// this checks if the paddle is moving right
@property BOOL movingRight;
// this is a score variable
@property int score;

@property int lives;

@property NSTimeInterval timeOfLastImpulse;
@property NSTimeInterval timePerMove;

@end

@implementation GameScene

{
    // set our paddle to be global
    Paddle *paddle;
    
    // set up a node tree to hold our all of our nodes
    SKNode *scene;
    
    // first ball needs to be global
    Ball *ball;

    // game barriers
    Barriers *rightBarrier, *topBarrier, *leftBarrier, *gameOverBarrier;
    
    // this will play the game music
    AVAudioPlayer *gameMusic, *gameOverMusic, *paddleSound;
    
    // score labels
    PointsLabel *scoreLabel, *highScoreLabel;
    
    // lives label
    SKLabelNode *lifeLabel;
}

// set up all of the categories here
static const uint32_t ballCategory = 0x1 << 0;

static const uint32_t paddleCategory = 0x1 << 1;
static const uint32_t barrierCategory = 0x1 << 2;
static const uint32_t gameOverBarrierCategory = 0x1 << 3;

@synthesize score;

//static const uint32_t barrierCategory = 0x1 << 1;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    // set up our node tree
    
    [self removeAllChildren];
    [self removeAllActions];
    [scene removeAllActions];
    [scene removeAllChildren];
    
    scene = [SKNode node];
    [self addChild:scene];
    
    // create game background
    SKSpriteNode *spaceBackground = [SKSpriteNode spriteNodeWithImageNamed:@"space"];
    spaceBackground.position = CGPointMake(0, 300);
    [scene addChild:spaceBackground];
    
    // initialize game music player
    NSURL *urlMusic = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ArrayBallMusic" ofType:@"mp3"]];
    gameMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:urlMusic error:nil];
    
    // initialize game over music
    NSURL *urlOver = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GameOverMusic" ofType:@"mp3"]];
    gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOver error:nil];
    
    // initialize paddle sound
    NSURL *urlPaddle = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"paddleSound" ofType:@"wav"]];
    paddleSound = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPaddle error:nil];

    // set the background color to white
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    // set anchor point to be in the middle toward the bottom of the screen
    self.anchorPoint = CGPointMake(0.5, 0.1);
    
    // contactDelegate is a protocol
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, -1);
    
    // create our paddle and add it to the scene (node tree)
    paddle = [Paddle paddle];
    [scene addChild:paddle];
    
    // setting score to 0
    self.score = 0;
    self.ballCounter = 0;
    
    // create our ball and add it to the scene
    ball = [Ball ball];
    ball.physicsBody.affectedByGravity = NO;
    [scene addChild:ball];
    
    self.ballCounter = 1;
    
    // create our barriers
    topBarrier = [Barriers topBarrier];
    leftBarrier = [Barriers leftBarrier];
    rightBarrier = [Barriers rightBarrier];
    gameOverBarrier = [Barriers gameOverBarrier];
    
    // add them to the scene
    [scene addChild:topBarrier];
    [scene addChild:leftBarrier];
    [scene addChild:rightBarrier];
    [scene addChild:gameOverBarrier];
    
    // add the buttons to the scene
    [scene addChild:[self leftButton]];
    [scene addChild:[self rightButton]];
    
    // add the tapToBegin label
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
    tapToBeginLabel.name = @"tapToBeginLabel";
    tapToBeginLabel.text = @"Tap to begin!";
    tapToBeginLabel.color = [UIColor blackColor];
    tapToBeginLabel.colorBlendFactor = 1.0;
    tapToBeginLabel.fontSize = 50.0;
    tapToBeginLabel.position = CGPointMake(0, 300);
    [scene addChild:tapToBeginLabel];
    [self animateWithPulse:tapToBeginLabel];
    
    [self loadScoreLabels];
    
    [self setUpCategories];
}

-(void)loadScoreLabels
{
    // properites of a score label
    scoreLabel = [PointsLabel pointsLabelWithFontNamed:@"CoolveticaRg-Regular"];
    scoreLabel.fontSize = 50;
    scoreLabel.name = @"scoreLabel";
    scoreLabel.position = CGPointMake(150, 600);
    scoreLabel.fontColor = [SKColor greenColor];
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [scene addChild:scoreLabel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger *retrievedScore  = [defaults integerForKey:@"highScoreLabel"];
    
    highScoreLabel = [PointsLabel pointsLabelWithFontNamed:@"CoolveticaRg-Regular"];
    highScoreLabel.fontSize = 50;
    highScoreLabel.name = @"highScoreLabel";
    highScoreLabel.position = CGPointMake(-150, 600);
    [highScoreLabel setPoints:retrievedScore];
    highScoreLabel.fontColor = [SKColor greenColor];
    highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [scene addChild:highScoreLabel];
    
    // set up number of lives
    self.lives = 3;
    
    lifeLabel = [SKLabelNode labelNodeWithFontNamed:@"CoolveticaRg-Regular"];
    lifeLabel.fontSize = 50;
    lifeLabel.name = @"lifeLabel";
    lifeLabel.position = CGPointMake(0, 600);
    lifeLabel.text = [NSString stringWithFormat:@"%i", self.lives];
    [scene addChild:lifeLabel];
    
    
}

-(void)setUpCategories
{
    // setting up ball categories
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = paddleCategory;
    ball.physicsBody.collisionBitMask = barrierCategory;
    
    paddle.physicsBody.categoryBitMask = paddleCategory;

    rightBarrier.physicsBody.categoryBitMask = barrierCategory;
    
    topBarrier.physicsBody.categoryBitMask = barrierCategory;
    
    leftBarrier.physicsBody.categoryBitMask = barrierCategory;
    
    gameOverBarrier.physicsBody.categoryBitMask = gameOverBarrierCategory;
    gameOverBarrier.physicsBody.contactTestBitMask = ballCategory;
}
 
// this creates the button that moves our paddle left
-(SKSpriteNode *)leftButton
{
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(325, 1500)];
    leftButton.name = @"leftButton";
    leftButton.position = CGPointMake(-180, -50);
    // Making it invisible
    leftButton.alpha = 0.0;
    return leftButton;
}

// this creates the button to move the paddle right
-(SKSpriteNode *)rightButton
{
    SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(325, 1500)];
    rightButton.name = @"rightButton";
    rightButton.position = CGPointMake(180, -50);
    // Making it invisible
    rightButton.alpha = 0.0;
    
    return rightButton;
}

-(void)start
{
    self.isStarted = YES;
    ball.physicsBody.affectedByGravity = YES;
    
    // this removes the tap to start label when the game starts
    [[scene childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    
    // play game music
    [gameMusic play];
}

// called when a ball reaches the bottom of the screen
-(void)gameOver
{
    self.isGameOver = YES;
    
    // game over label creation
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
    gameOverLabel.name = @"gameOverLabel";
    gameOverLabel.text = @"Game Over!";
    gameOverLabel.color = [UIColor blueColor];
    gameOverLabel.colorBlendFactor = 1.0;
    gameOverLabel.fontSize = 50.0;
    gameOverLabel.position = CGPointMake(0, 300);
    [scene addChild:gameOverLabel];
    
    // tap to reset label creation
    SKLabelNode *tapToResetLabel = [SKLabelNode labelNodeWithFontNamed:@"AmericanTypewriter-Bold"];
    tapToResetLabel.name = @"tapToResetLabel";
    tapToResetLabel.text = @"Tap to reset!";
    tapToResetLabel.color = [UIColor purpleColor];
    tapToResetLabel.colorBlendFactor = 1.0;
    tapToResetLabel.fontSize = 30.0;
    tapToResetLabel.position = CGPointMake(0, 150);
    [scene addChild:tapToResetLabel];
    [self animateWithPulse:tapToResetLabel];
    
    [self updateHighScore];
}

// this is called when everything is to be restarted
// this will only be called when game is over
-(void)restartGame
{
    for (SKNode* node in scene.children) {
        [node removeFromParent];
        [node removeAllActions];
    }
    
    [gameOverMusic stop];
    
    // create a new gamescene
    GameScene *newScene = [[GameScene alloc] initWithSize:self.frame.size];
    
    // this fixes the strange problem of the game shrinking in size
    newScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // present the new game
    [self.view presentScene:newScene];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // this starts the movement of the ball
    if (!self.isStarted) {
        [self start];
    }
    
    else if (self.isGameOver) {
        [self restartGame];
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
    }
    
    // if the user lets go of the right button, stop paddle movement
    else if ([node.name isEqualToString:@"rightButton"]) {
        self.movingRight = NO;
    }
}

// this method adds a new ball to the game when needed
-(void)addBall
{
    Ball *newBall = [Ball ball];
    newBall.position = CGPointMake(paddle.position.x, paddle.position.y + 3);
    
    newBall.physicsBody.categoryBitMask = ballCategory;
    newBall.physicsBody.contactTestBitMask = paddleCategory;
    newBall.physicsBody.collisionBitMask = barrierCategory;
    
    [scene addChild:newBall];
    self.ballCounter++;
}

-(void)updateHighScore
{
    if (scoreLabel.number > highScoreLabel.number) {
        [highScoreLabel setPoints:scoreLabel.number];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:highScoreLabel.number forKey:@"highScoreLabel"];
    }
}

// see comment below
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (self.isTouching && self.movingLeft) {
        [paddle movePaddleLeft:-10];
    }
    
    else if (self.isTouching && self.movingRight) {
        [paddle movePaddleRight:10];
    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // if a body in the scene makes contact with the paddle
    // shoot the ball back up
    if ((firstBody.categoryBitMask & ballCategory) != 0 && (secondBody.categoryBitMask & paddleCategory) != 0) {
        // move ball up
        [firstBody applyImpulse:CGVectorMake(arc4random() % 20 + 50, arc4random() % 20 + 70)];
        
        // increment score
        [scoreLabel increment];
        
        // if the score is divisible by 5
        // add another ball using an action perform selector
        if (scoreLabel.number % 5 == 0 && scoreLabel.number != 0) {
            [scene runAction:[SKAction performSelector:@selector(addBall) onTarget:self]];
        }
        
        // play paddle sound
        [paddleSound play];
    }
    
    // if a ball hits the game over barrier below the paddle
    // the game is over
    else if ((firstBody.categoryBitMask & ballCategory) != 0 && (secondBody.categoryBitMask & gameOverBarrierCategory) != 0) {
        
        // checks to see if the game is over
        if (!self.isGameOver) {
        
            // decrement lives
            self.lives--;
        
            // decrement ball counter
            self.ballCounter--;
        
            // if the user sucks an loses a life when only one ball is present
            // add in another ball
            if (self.ballCounter == 0 ) {
                [scene runAction:[SKAction performSelector:@selector(addBall) onTarget:self]];
            }
        
            // update lives label
            lifeLabel.text = [NSString stringWithFormat:@"%i", self.lives];
        }
        
        // if the user has 0 lives
        // the game is over
        if (self.lives == 0) {
            // stop game music
            [gameMusic stop];
            // play game over music
            [gameOverMusic play];
        
            // call game over method
            [self gameOver];
        
            // set this so that when the remaining balls fall down, they don't touch the paddle
            paddle.physicsBody.categoryBitMask = 0;
        }
    }
}
 
// this animates the pulsing effect of the tapToBegin/Reset labels
-(void)animateWithPulse:(SKNode *)node
{
    // this is the animation to make our tapToBegin/tapToReset disappear
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    // this is the action to make our tapToBegin/tapToReset labels appear
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.6];
    
    // this is our pulse action that will run the two animations
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

@end
