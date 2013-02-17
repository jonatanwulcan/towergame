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

@implementation Level

- (id) initWithLevelNumber:(int) levelNumber {
    self = [super init];
    
    NSMutableString* levelString = [NSMutableString stringWithCapacity:100];
    NSString* path;
    NSString* levelStringPart;
    
    path = [[NSBundle mainBundle] pathForResource:@"level01" ofType:@"txt"];
    levelStringPart = [NSString stringWithContentsOfFile:path
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
    [levelString appendString:levelStringPart];

    path = [[NSBundle mainBundle] pathForResource:@"level00" ofType:@"txt"];
    levelStringPart = [NSString stringWithContentsOfFile:path
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
    [levelString appendString:levelStringPart];

    int wpos = 0;
    levelData = malloc(levelString.length);
    for(int i=0;i<levelString.length;i++) {
        unichar cc = [levelString characterAtIndex:i];
        switch(cc) {
            case '\r':
            case '\n':
                break;
            case '_':
                levelData[wpos++] = TILE_FLOOR;
                break;
            case '[':
                levelData[wpos++] = TILE_FLOOR_LEFT;
                break;
            case ']':
                levelData[wpos++] = TILE_FLOOR_RIGHT;
                break;
            case '(':
                levelData[wpos++] = TILE_CORNER_LEFT;
                break;
            case ')':
                levelData[wpos++] = TILE_CORNER_RIGHT;
                break;
            case '=':
                levelData[wpos++] = TILE_BASEFLOOR;
                break;
            case '{':
                levelData[wpos++] = TILE_BASECORNER_LEFT;
                break;
            case '}':
                levelData[wpos++] = TILE_BASECORNER_RIGHT;
                break;
            case '/':
                levelData[wpos++] = TILE_WALL_LEFT;
                break;
            case '\\':
                levelData[wpos++] = TILE_WALL_RIGHT;
                break;
            case '>':
                levelData[wpos++] = TILE_SPIKE_RIGHT;
                break;
            case '<':
                levelData[wpos++] = TILE_SPIKE_LEFT;
                break;
            case 'v':
                levelData[wpos++] = TILE_SPIKE_DOWN;
                break;
            case '^':
                levelData[wpos++] = TILE_SPIKE_UP;
                break;
            default:
                levelData[wpos++] = TILE_NONE;
                break;
        }
    }
    levelSize = wpos;
    return self;
}

- (int) tileTypeWithX:(int) fx y:(int) fy {
    int x=floor(fx/32.0);
    int y=floor(fy/32.0);
    
    int ldx = x+10;
    int ldy = levelSize/20-LEVEL_OFFSET-y;
    if(ldx < 0 || ldx >= 20 || ldy < 0 || ldy >= levelSize/20) {
        return TILE_NONE;
    }
    return levelData[ldy*20+ldx];
}

- (void) drawWithFadeLimit:(float) fadeLimit baseFloor:(float) baseFloor frameNumber:(int) frameNumber {
    int cx = [self round:cameraX];
    int cy = [self round:cameraY];
    int spikeAnim = (frameNumber/20)%4;
    
    for(int y=cy-640;y<=cy+640;y+=32) {
        for(int x=cx-320;x<=cx+320;x+=32) {
            int floorFade = 0;
            if(y > baseFloor) {
                if(fadeLimit - 1 > y) {
                    floorFade = 1;
                }
                if(fadeLimit - 15 > y) {
                    floorFade = 2;
                }
                if(fadeLimit - 30 > y) {
                    floorFade = 3;
                }
            }
            
            // TILE TYPE WITH X Y
            int ldx = floor(x/32.0)+10;
            int ldy = levelSize/20-LEVEL_OFFSET-floor(y/32.0);
            int tileType;
            if(ldx < 0 || ldx >= 20 || ldy < 0 || ldy >= levelSize/20) {
                tileType = TILE_NONE;
            } else {
                tileType = levelData[ldy*20+ldx];
            }

            
            switch(tileType) {
                case TILE_BASEFLOOR:
                    [sprites[SPRITE_BASEFLOOR] drawWithX:x y:y z:1 flip:false];
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
                case TILE_CORNER_LEFT:
                    [sprites[SPRITE_CORNER_LEFT_0+floorFade] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_CORNER_RIGHT:
                    [sprites[SPRITE_CORNER_RIGHT_0+floorFade] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_BASECORNER_LEFT:
                    [sprites[SPRITE_BASECORNER_LEFT] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_BASECORNER_RIGHT:
                    [sprites[SPRITE_BASECORNER_RIGHT] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_SPIKE_RIGHT:
                    [sprites[SPRITE_SPIKE_RIGHT_0+spikeAnim] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_SPIKE_LEFT:
                    [sprites[SPRITE_SPIKE_LEFT_0+spikeAnim] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_SPIKE_UP:
                    [sprites[SPRITE_SPIKE_UP_0+spikeAnim] drawWithX:x y:y z:1 flip:false];
                    break;
                case TILE_SPIKE_DOWN:
                    [sprites[SPRITE_SPIKE_DOWN_0+spikeAnim] drawWithX:x y:y z:1 flip:false];
                    break;

            }
        }
    }
}

- (int) round:(float) f {
    return (((int)f)/32)*32-16;
}
@end
