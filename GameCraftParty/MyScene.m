//
//  MyScene.m
//  GameCraftParty
//
//  Created by Marc O'Morain on 17/05/2014.
//  Copyright (c) 2014 Marc. All rights reserved.
//

#import "MyScene.h"
#import "Xbox360ControllerManager.h"
#import "Xbox360Controller.h"
#include <math.h>

@interface MyScene()
@property (retain) Xbox360ControllerManager* cm;
@property (retain) NSMutableOrderedSet* controllers;
@property (retain) SKSpriteNode* player1;
@property (retain) SKSpriteNode* zombie;
@property (retain) SKTexture* zombieTex;
@property (retain) SKTexture* zombieBase;
@property (retain) SKLabelNode* label;
@property (retain) NSMutableArray* zombies;
@property (retain) SKAction* zombieWalk;
@end


@implementation MyScene

-(void)load {
    self.zombieTex = [SKTexture textureWithImageNamed:@"zombie_topdown.png"];
    NSMutableArray* walk = [NSMutableArray new];
    const double width  = 128.0 / 4608.0;
    const double height = 128.0 / 1024.0;
    for (int frame = 0; frame < 4; frame++) {
        [walk addObject:[SKTexture textureWithRect:CGRectMake(frame*width, 0, width, height) inTexture:self.zombieTex]];
    }
    self.zombieWalk = [SKAction repeatActionForever:[SKAction animateWithTextures:walk timePerFrame:0.1]];
    self.zombieBase = [walk firstObject];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        self.zombies = [NSMutableArray new];

        [self load];


        self.controllers = [[NSMutableOrderedSet alloc] initWithCapacity:4];

        self.player1 = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        self.player1.position = CGPointMake(100, 100);
        self.player1.scale = 0.5;

        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];

        [self.player1 runAction:[SKAction repeatActionForever:action]];
        [self addChild:self.player1];

        self.cm = [Xbox360ControllerManager sharedInstance];


        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 36;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        self.label = myLabel;


        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserverForName:Xbox360ControllerAddedNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *notification)
        {
            Xbox360Controller* controller = notification.object;
            [self.controllers addObject:controller];
            NSLog(@"Added controller %@ (%ld of 4)", controller.name, self.controllers.count);

        }];

        [center addObserverForName:Xbox360ControllerRemovedNotification
                            object:nil
                             queue:nil
                        usingBlock:^(NSNotification *notification)
         {
             Xbox360Controller* controller = notification.object;
             [self.controllers removeObject:controller];
             NSLog(@"Controller %@ disconnected", controller.name);
         }];
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
     /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    

    
//    sprite.position = location;
//    sprite.scale = 0.5;
    
//    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    
//    [sprite runAction:[SKAction repeatActionForever:action]];
    
//    [self addChild:sprite];
}

static double clean(int x) {
    double dx = (double)x / 32767.0;

    // clamp
    dx = fmax(fmin(1.0, dx), -1.0);

    // dead-zone
    if (fabs(dx) < 0.3) {
        dx = 0;
    }
    return dx;
}

static double randomd() {
    return ((double)rand() / (double)RAND_MAX);
}
-(SKSpriteNode*)makeZombie {

    SKSpriteNode* z = [SKSpriteNode spriteNodeWithTexture:self.zombieBase];
    z.size = CGSizeMake(128, 128);

    double x = randomd() * self.frame.size.width;
    double y = self.frame.size.height;
    CGPoint position = CGPointMake(x,y);
    z.position = position;
    z.scale = 1;
    [z runAction:self.zombieWalk];
    [z runAction:[SKAction moveToY:0 duration:10]];
    return z;
}

-(void)update:(CFTimeInterval)currentTime {

    if ((rand() % 64) == 0) {
        SKSpriteNode* z = [self makeZombie];
        [self addChild:z];
        [self.zombies addObject:z];
        NSLog(@"Zombie add");
    }
    /* Called before each frame is rendered */

    for (Xbox360Controller* controller in self.controllers) {

        int speed = 10;

        CGPoint p = self.player1.position;
        if (controller.leftStickInDownPosition) {
            p.y -= speed;
        }
        if (controller.leftStickInUpPosition) {
            p.y += speed;
        }
        if (controller.leftStickInRightPosition) {
            p.x += speed;
        }
        if (controller.leftStickInLeftPosition) {
            p.x -= speed;
        }


        self.player1.position = p;

        self.label.text = [NSString stringWithFormat:@"%08x %08x %10d %10d",
                           controller.leftStickHorizontal, controller.leftStickVertical, controller.leftStickInRightPosition, controller.leftStickInRightPosition];
        //        self.label.text = [NSString stringWithFormat:@"%08x %08x",controller.leftStickHorizontal, controller.leftStickVertical];
    }



}

@end
