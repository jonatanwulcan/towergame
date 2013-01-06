//
//  Tile.h
//  towergame
//
//  Created by Jonatan Wulcan on 2013-01-02.
//  Copyright (c) 2013 Jonatan Wulcan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tile : NSObject {
    float x;
    float y;
    int type;
    int sprite;
}

- (id) initWithX:(float) _x y:(float) _y type:(int) _type sprite:(int) _sprite;
- (void) draw;
- (bool) overlapsWithX:(float) ox y:(float) oy width:(float) owidth height:(float) oheight;
- (int) type;
- (float) getY;
@end
