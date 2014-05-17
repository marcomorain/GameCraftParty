#import "Player.h"
#import "Sprites.h"

@interface Player()
@property int lastAngle;
@property (retain) NSArray* shoot;
@property (retain) NSArray* walk;
@property (retain) NSArray* idle;
@end

@implementation Player


-(id) init {
    self = [super init];
    SKTexture* texture = [SKTexture textureWithImageNamed:@"Pistol.png"];

    self.lastAngle = 0;

    NSMutableArray* shoot = [NSMutableArray new];
    NSMutableArray* idle  = [NSMutableArray new];
    NSMutableArray* walk  = [NSMutableArray new];

    NSRange shootRange = NSMakeRange(0, 2);
    NSRange walkRange  = NSMakeRange(2, 4);
    NSRange idleRange  = NSMakeRange(5, 1);

    for (int i=0; i<8; i++) {
        NSArray* strip = [Sprites clipWithTexture:texture frames:6 x:0 y:7-i width:32 height:32];

        [shoot addObject:[SKAction animateWithTextures:[strip subarrayWithRange:shootRange] timePerFrame:0.1]];
        [walk  addObject:[SKAction repeatActionForever:[SKAction animateWithTextures:[strip subarrayWithRange:walkRange ] timePerFrame:0.1]]];
        [idle  addObject:[SKAction animateWithTextures:[strip subarrayWithRange:idleRange ] timePerFrame:0.1]];
    }

    self.sprite = [SKSpriteNode spriteNodeWithTexture:[[Sprites clipWithTexture:texture frames:1 x:0 y:0 width:32 height:32] firstObject]];

    self.sprite.position = CGPointMake(100, 100);
    self.sprite.scale = 2;

    self.shoot = [NSArray arrayWithArray:shoot];
    self.walk  = [NSArray arrayWithArray:walk];
    self.idle  = [NSArray arrayWithArray:idle];

    [self.sprite runAction:[self.idle firstObject]];
    return self;
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


-(void)updateWithTimeDelta:(CFTimeInterval)delta andController:(Xbox360Controller*)controller {
    double speed = 200;

    double x = clean(controller.rightStickHorizontal);
    double y = clean(controller.rightStickVertical);

    const double angle = atan2(x, y) + (M_PI);

    if (fabs(x) > 0 || fabs(y)) {

        int a = 0;

        double d = angle + (0.785398163397448/2.0);

        while (d > 0.785398163397448) {
            a++;
            d -= 0.785398163397448;
        }

        a = (a % 8);

        if (a != self.lastAngle) {
            self.lastAngle = a;
            [self.sprite removeAllActions];
            [self.sprite runAction:[self.walk objectAtIndex:a]];
        }
    } else {
        [self.sprite removeAllActions];
        [self.sprite runAction:[self.idle objectAtIndex:self.lastAngle]];
    }

    CGPoint p = self.sprite.position;

    p.x -= (speed * delta * x);
    p.y += (speed * delta * y);
    self.sprite.position = p;
    self.text = [NSString stringWithFormat:@"%d %.2f", self.lastAngle, angle];
}

@end
