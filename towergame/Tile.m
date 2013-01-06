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

- (id) initWithX:(float) _x y:(float) _y type:(int) _type sprite:(int)_sprite {
    self = [super init];
    x = _x;
    y = _y;
    type = _type;
    sprite = _sprite;
    return self;
}

- (void) draw {
    [sprites[sprite] drawWithX:x y:y];
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
