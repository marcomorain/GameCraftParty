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
@end


@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        self.controllers = [[NSMutableOrderedSet alloc] initWithCapacity:4];

        self.player1 = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        self.player1.position = CGPointMake(100, 100);

        //    sprite.position = location;
        self.player1.scale = 0.5;

        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];

        [self.player1 runAction:[SKAction repeatActionForever:action]];
        [self addChild:self.player1];




        self.cm = [Xbox360ControllerManager sharedInstance];










        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];


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
    dx = fmax(fmin(1, dx), -1);

    // dead-zone
    if (fabs(dx) < 0.1) {
        dx = 0;
    }
    return dx;
}
-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    for (Xbox360Controller* controller in self.controllers) {
        double x = clean(controller.leftStickHorizontal);
        double y = clean(controller.leftStickDeadZoneThreshold)
        x =
        NSLog(@"%g", x);
    }



}

@end
