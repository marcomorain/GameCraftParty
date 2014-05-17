
#import "Sprites.h"

@implementation Sprites

+(NSArray*)clipWithTexture:(SKTexture*) texture frames:(int)frames x:(int)x y:(int)y width:(int) w height:(int) h {

    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:frames];

    const double width  = ((double)w) / texture.size.width;
    const double height = ((double)h) / texture.size.height;

    int start = x;
    int end = start + frames;
    for (int i = start; i < end; i++) {
        [result addObject:[SKTexture textureWithRect:CGRectMake(i*width, y*height, width, height) inTexture:texture]];
    }
    return result;
}


@end
