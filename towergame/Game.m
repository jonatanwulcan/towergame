//
//  Game.m
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-27.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

#import "common.h"

#import "Game.h"
#import "Sprite.h"
#import "Tile.h"

enum {
    PLAYERSTATE_WALKING_LEFT,
    PLAYERSTATE_WALKING_RIGHT,
};

@implementation Game

-(id) init {    
    self = [super init];
    level = [[Level alloc] initWithLevelNumber:0];
    frameNum = 0;
    playerState = PLAYERSTATE_WALKING_LEFT;
    playerX = 0;
    playerY = 0;
    playerVX = 5;
    playerVY = 0.0;
    jumpCount = 0;
    cameraTargetY = 0;
    cameraVY = 0;
    isDead = false;

    return self;
}

-(void) update {
    frameNum++;
    
    // Is dead?
    if(!isDead && playerY < cameraTargetY-350) {
        isDead = true;
        cameraTargetY = -100+150;
    }
    
    if(isDead && playerY < -100) {
        isDead = false;
    }
    
    // Gravity
    playerVY -= 1.0;
    if(playerVY < -12) playerVY = -12;
    
    NSArray* tiles = [level getNearbyTilesWithX:playerX y:playerY];
    
    // Check collisions
    float newPlayerX = playerX + playerVX;
    float newPlayerY = playerY + playerVY;
    for(Tile* tile in tiles) {
        if(![tile overlapsWithX:newPlayerX y:newPlayerY width:32 height:64]) continue;
        switch([tile type]) {
            case TILE_FLOOR:
                if(playerVY < 0 && ![tile overlapsWithX:newPlayerX y:playerY width:32 height:64] && !isDead) {
                    playerY = [tile getY] + 16 + 32;
                    if(playerY+150 > cameraTargetY) cameraTargetY = playerY+150;
                    playerVY = 0;
                    jumpCount = 0;
                }
                break;
            case TILE_WALL_LEFT:
                playerVX = 5;
                break;
            case TILE_WALL_RIGHT:
                playerVX = -5;
                break;
        }
    }
    
    // Update position
    playerX = playerX + playerVX;
    playerY = playerY + playerVY;
    
    // Update camera
    float camSpeed = 0.1 * (isDead?10:1);
    float cameraWillHitY;
    if(cameraVY > 0)
        cameraWillHitY = cameraY + cameraVY*((cameraVY/camSpeed)+1)/2.0;
    else
        cameraWillHitY = cameraY - cameraVY*((cameraVY/camSpeed)+1)/2.0;
    if(fabs(cameraY-cameraTargetY) < 5) {
        cameraVY = 0;
    } else if(cameraWillHitY>cameraTargetY) {
        cameraVY -= camSpeed;
    } else if(cameraWillHitY<cameraTargetY) {
        cameraVY += camSpeed;
    }
    cameraY += cameraVY;
}

-(void) draw {
    float bgz = 2;
    float bgx = floor(cameraX/bgz/256.0)*256.0;
    float bgy = floor(cameraY/bgz/256.0)*256.0;
    for(int i=-3;i<=3;i++) for(int j=-3;j<=3;j++) {
        [sprites[SPRITE_BACKGROUND] drawWithX:bgx+i*256 y:bgy+j*256 z:bgz flip:false];
    }
    
    [level draw];
    [self drawPlayer];
}

-(void) drawPlayer {
    if(jumpCount == 2) {
        [sprites[SPRITE_PLAYER_PRIOUETTE_0+(frameNum/5)%4] drawWithX:playerX y:playerY flip:playerVX<0];
    } else {
        if(fabs(playerVY) < 2) {
            [sprites[SPRITE_PLAYER_WALK_0+(frameNum/5)%8] drawWithX:playerX y:playerY flip:playerVX<0];
        } else if(playerVY > 0) {
            [sprites[SPRITE_PLAYER_JUMP] drawWithX:playerX y:playerY flip:playerVX<0];
        } else if(playerVY < 0) {
            [sprites[SPRITE_PLAYER_FALL] drawWithX:playerX y:playerY flip:playerVX<0];
        }
    }
}

-(void) jump {
    if(jumpCount == 0 && playerVY > -7 && !isDead) {
        playerVY = 15.0;
        jumpCount++;
    } else if(jumpCount == 1 && !isDead) {
        playerVY = 15.0;
        playerVX *= -1;
        jumpCount++;
    }
}
@end
