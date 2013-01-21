//
//  Level.m
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-27.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

#import "common.h"

#import "Level.h"
#import "Sprite.h"

int levelData[] = {
    2,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,5,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,5,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,4,5,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,4,1,5,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,4,5,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,1,1,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,1,1,1,1,1,5,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,4,1,1,5,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,4,1,1,1,1,1,1,1,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,1,1,1,1,1,1,5,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,3,
    
    
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,
};

int levelData2Tile[] = {
    0,
    TILE_FLOOR,
    TILE_WALL_LEFT,
    TILE_WALL_RIGHT,
    TILE_FLOOR_LEFT,
    TILE_FLOOR_RIGHT,
    TILE_BASEFLOOR
};

@implementation Level

- (id) initWithLevelNumber:(int) levelNumber {
    self = [super init];
    return self;
}

- (int) tileTypeWithX:(int) fx y:(int) fy {
    int x=floor(fx/32.0);
    int y=floor(fy/32.0);
    
    int ldx = x+10;
    int ldy = 55-y;
    if(ldx < 0 || ldx >= 20 || ldy < 0 || ldy >= 80) {
        return 0;
    }
    return levelData2Tile[levelData[ldy*20+ldx]];
}

- (void) drawWithFadeLimit:(float) fadeLimit {
    int cx = [self round:cameraX];
    int cy = [self round:cameraY];
    
    for(int y=cy-640;y<=cy+640;y+=32) {
        for(int x=cx-320;x<=cx+320;x+=32) {
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
            
            switch([self tileTypeWithX:x y:y]) {
                case TILE_BASEFLOOR:
                    [sprites[SPRITE_FLOOR_0] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_FLOOR:
                    [sprites[SPRITE_FLOOR_0+floorFade] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_FLOOR_LEFT:
                    [sprites[SPRITE_FLOOR_LEFT_0+floorFade] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_FLOOR_RIGHT:
                    [sprites[SPRITE_FLOOR_RIGHT_0+floorFade] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_WALL_LEFT:
                    [sprites[SPRITE_WALL_LEFT] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_WALL_RIGHT:
                    [sprites[SPRITE_WALL_RIGHT] drawWithX:x y:y z:1 flip:false];
                    break;
            }
        }
    }
}

- (int) round:(float) f {
    return (((int)f)/32)*32-16;
}
@end
