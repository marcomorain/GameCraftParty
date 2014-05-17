#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Sprites : NSObject

+(NSArray*)clipWithTexture:(SKTexture*) texture frames:(int)frames x:(int)x y:(int)y width:(int) w height:(int) h;

@end
