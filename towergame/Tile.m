//
//  Tile.m
//  towergame
//
//  Created by Jonatan Wulcan on 2013-01-02.
//  Copyright (c) 2013 Jonatan Wulcan. All rights reserved.
//

#import "common.h"

#import "Tile.h"
#import "Sprite.h"

@implementation Tile

- (id) initWithX:(float) _x y:(float) _y type:(int) _type {
    self = [super init];
    x = _x;
    y = _y;
    type = _type;
    return self;
}

- (void) drawWithFadeLimit:(float) fadeLimit {
    int floorFade = 0;
    if(fadeLimit - 1 > y) {
        floorFade = 1;
    }
    if(fadeLimit - 15 > y) {
        floorFade = 2;
    }
    if(fadeLimit - 30 > y) {
        floorFade = 3;
    }

    switch(type) {
        case TILE_BASEFLOOR:
            [sprites[SPRITE_FLOOR_0] drawWithX:x y:y];
            break;
        case TILE_FLOOR:
            [sprites[SPRITE_FLOOR_0+floorFade] drawWithX:x y:y];
            break;
        case TILE_FLOOR_LEFT:
            [sprites[SPRITE_FLOOR_LEFT_0+floorFade] drawWithX:x y:y];
            break;
        case TILE_FLOOR_RIGHT:
            [sprites[SPRITE_FLOOR_RIGHT_0+floorFade] drawWithX:x y:y];
            break;
        case TILE_WALL_LEFT:
            [sprites[SPRITE_WALL_LEFT] drawWithX:x y:y];
            break;
        case TILE_WALL_RIGHT:
            [sprites[SPRITE_WALL_RIGHT] drawWithX:x y:y];
            break;
    }
}

- (bool) overlapsWithX:(float) ox y:(float) oy width:(float) owidth height:(float) oheight {
    return fabs(ox-x) < 16+owidth/2 && fabs(oy-y) < 16+oheight/2;
}

- (int) type {
    return type;
}

- (float) getY {
    return y;
}
@end
