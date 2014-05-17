//
//  AppDelegate.m
//  GameCraftParty
//
//  Created by Marc O'Morain on 17/05/2014.
//  Copyright (c) 2014 Marc. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    SKScene *scene = [MyScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
