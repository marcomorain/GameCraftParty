
#import "MyScene.h"
#import "Xbox360ControllerManager.h"
#import "Xbox360Controller.h"
#import "Sprites.h"
#import "Player.h"
#import "Zombie.h"
#include <math.h>

@interface MyScene()
@property (retain) Xbox360ControllerManager* cm;
@property (retain) NSMutableOrderedSet* controllers;
@property (retain) Player* player1;
@property (retain) SKSpriteNode* zombie;
@property (retain) SKTexture* zombieTex;
@property (retain) SKTexture* zombieBase;
@property (retain) SKLabelNode* label;
@property (retain) NSMutableArray* zombies;

@property (retain) NSArray* zombieIdle;
@property (retain) NSArray* zombieWalk;
@property (retain) NSArray* zombieBite;
@property (retain) NSArray* zombieFall;
@property (retain) NSArray* zombieFrag;

@property (retain) SKTexture* floorTex;
@property CFTimeInterval lastFrame;
@end

@implementation MyScene

-(void)load {
    self.floorTex = [SKTexture textureWithImageNamed:@"ik_floor_met64e.jpg"];
    self.zombieTex = [SKTexture textureWithImageNamed:@"zombie_topdown.png"];

    NSMutableArray* idle = [NSMutableArray new];
    NSMutableArray* walk = [NSMutableArray new];
    NSMutableArray* bite = [NSMutableArray new];
    NSMutableArray* fall = [NSMutableArray new];
    NSMutableArray* frag = [NSMutableArray new];


    NSRange idleRange = NSMakeRange( 0,  4);
    NSRange walkRange = NSMakeRange( 4,  8);
    NSRange biteRange = NSMakeRange(12, 10);
    NSRange fallRange = NSMakeRange(22,  6);
    NSRange fragRange = NSMakeRange(28,  8);
    for (int i=0; i<8; i++) {
        NSArray* strip = [Sprites clipWithTexture:self.zombieTex frames:36 x:0 y:7-i width:128 height:128];
        [idle addObject:[SKAction repeatActionForever:[SKAction animateWithTextures:[strip subarrayWithRange:idleRange] timePerFrame:0.1]]];
        [walk addObject:[SKAction repeatActionForever:[SKAction animateWithTextures:[strip subarrayWithRange:walkRange] timePerFrame:0.1]]];
        [bite addObject:[SKAction animateWithTextures:[strip subarrayWithRange:biteRange] timePerFrame:0.1]];
        [fall addObject:[SKAction animateWithTextures:[strip subarrayWithRange:fallRange] timePerFrame:0.1]];
        [frag addObject:[SKAction animateWithTextures:[strip subarrayWithRange:fragRange] timePerFrame:0.1]];
    }

    self.zombieBase = [[Sprites clipWithTexture:self.zombieTex frames:1 x:0 y:0 width:128 height:128] firstObject];

    self.zombieIdle = [NSArray arrayWithArray:idle];
    self.zombieWalk = [NSArray arrayWithArray:walk];
    self.zombieBite = [NSArray arrayWithArray:bite];
    self.zombieFall = [NSArray arrayWithArray:fall];
    self.zombieFrag = [NSArray arrayWithArray:frag];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        self.zombies = [NSMutableArray new];

        [self load];

        self.controllers = [[NSMutableOrderedSet alloc] initWithCapacity:4];
        self.cm = [Xbox360ControllerManager sharedInstance];


        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.65 blue:0.3 alpha:1.0];

        for (int i=0; i<32; i++){
            for (int j=0; j<32; j++){
                SKSpriteNode* node = [SKSpriteNode spriteNodeWithTexture:self.floorTex];
                node.position = CGPointMake(i*self.floorTex.size.width, j*self.floorTex.size.height);
                [self addChild:node];
            }
        }

        self.player1 = [[Player alloc] init];
        [self addChild:self.player1.sprite];

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
    
//    CGPoint location = [theEvent locationInNode:self];
    

    
//    sprite.position = location;
//    sprite.scale = 0.5;
    
//    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    
//    [sprite runAction:[SKAction repeatActionForever:action]];
    
//    [self addChild:sprite];
}

static double randomd() {
    return ((double)rand() / (double)RAND_MAX);
}

-(Zombie*)makeZombie {

    SKSpriteNode* z = [SKSpriteNode spriteNodeWithTexture:self.zombieBase];
    z.size = CGSizeMake(128, 128);

    double x = randomd() * self.frame.size.width;
    double y = self.frame.size.height;
    CGPoint position = CGPointMake(x,y);
    z.position = position;
    z.scale = 1;
    [z runAction:[self.zombieWalk objectAtIndex:7]];

    Zombie* result = [Zombie new];
    result.state = ZOMBIE_WALK;
    result.sprite = z;
    return result;
}

- (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}


-(void)updateZombie:(Zombie*)zombie {

    switch (zombie.state) {
        case ZOMBIE_WALK:
            if ([self distanceBetween:zombie.sprite.position and:self.player1.sprite.position] < 70) {
                zombie.state = ZOMBIE_BITE;
                [zombie.sprite removeAllActions];
                [zombie.sprite runAction:[self.zombieBite objectAtIndex:7] completion:^() {
                    zombie.state = ZOMBIE_WALK;
                    [zombie.sprite removeAllActions];
                    [zombie.sprite runAction:[SKAction moveToY:0 duration:10]];
                    [zombie.sprite runAction:[self.zombieWalk objectAtIndex:7]];
                }];
            }
            break;

        case ZOMBIE_BITE:
            break;

        default:
            break;
    }
}

-(void)update:(CFTimeInterval)currentTime {

    CFTimeInterval delta = self.lastFrame - currentTime;


    if ((rand() % 64) == 0) {
        Zombie* z = [self makeZombie];
        [z.sprite runAction:[SKAction moveToY:0 duration:10]];
        [self addChild:z.sprite];
        [self.zombies addObject:z];
    }
    /* Called before each frame is rendered */

    for (Xbox360Controller* controller in self.controllers) {
        [self.player1 updateWithTimeDelta:delta andController:controller];
        self.label.text = self.player1.text;
    }

    for (Zombie* zombie in self.zombies) {
        [self updateZombie:zombie];
    }


    self.lastFrame = currentTime;
}

@end
