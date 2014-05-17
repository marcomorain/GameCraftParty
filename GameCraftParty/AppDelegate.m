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
    const int w = 1280;
    const int h = 720;
    const CGSize size = CGSizeMake(w, h);
    /* Pick a size for the scene */
    SKScene *scene = [MyScene sceneWithSize:size];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsDrawCount = YES;

    [self.window setContentMaxSize:size];
    [self.window setContentMinSize:size];
    [self.window update];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
