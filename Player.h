#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Xbox360Controller.h"

@interface Player : NSObject

@property double health; // 100
@property (retain) SKSpriteNode* sprite;
@property (retain) NSString* text;

-(void)updateWithTimeDelta:(CFTimeInterval)delta atTime:(CFAbsoluteTime)time andController:(Xbox360Controller*)controller;

@end
