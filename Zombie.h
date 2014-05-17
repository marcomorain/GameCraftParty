#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


typedef enum {
    ZOMBIE_WALK,
    ZOMBIE_BITE,
} ZombieState;

@interface Zombie : NSObject

@property (retain) SKSpriteNode* sprite;
@property ZombieState state;

@end
