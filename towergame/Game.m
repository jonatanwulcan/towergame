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

@implementation Game

-(id) init {    
    self = [super init];
    level = [[Level alloc] initWithLevelNumber:0];
    frameNum = 0;
    playerX = 0;
    playerY = 0;
    playerVX = WALK_SPEED;
    playerVY = 0.0;
    jumpCount = 0;
    cameraTargetY = 0;
    cameraVY = 0;
    isDead = false;
    currentBaseFloor = -200;

    return self;
}

-(void) update {
    frameNum++;
    
    // Is dead?
    if(!isDead && playerY < cameraTargetY-DEATH_LIMIT) {
        isDead = true;
        cameraTargetY = currentBaseFloor+CAMERA_ADD;
    }
    
    if(isDead && playerY < currentBaseFloor+32) {
        isDead = false;
    }
    
    // Gravity
    playerVY += GRAVITY;
    if(playerVY < MAX_SPEED_FALL) playerVY = MAX_SPEED_FALL;
    
    NSArray* tiles = [level getNearbyTilesWithX:playerX y:playerY];
    
    // Check collisions
    float newPlayerX = playerX + playerVX;
    float newPlayerY = playerY + playerVY;
    for(Tile* tile in tiles) {
        if(![tile overlapsWithX:newPlayerX y:newPlayerY width:32 height:64]) continue;
        switch([tile type]) {
            case TILE_BASEFLOOR:
                if(playerVY < 0 && ![tile overlapsWithX:newPlayerX y:playerY width:32 height:64]) {
                    playerY = [tile getY] + 16 + 32;
                    if([tile getY]+CAMERA_ADD > cameraTargetY) cameraTargetY = [tile getY]+CAMERA_ADD;
                    playerVY = 0;
                    jumpCount = 0;
                }
                break;

            case TILE_FLOOR:
            case TILE_FLOOR_LEFT:
            case TILE_FLOOR_RIGHT:
                if(playerVY < 0 && ![tile overlapsWithX:newPlayerX y:playerY width:32 height:64] && !isDead && [tile getY] > cameraTargetY - DEATH_LIMIT ) {
                    playerY = [tile getY] + 16 + 32;
                    if([tile getY]+CAMERA_ADD > cameraTargetY) cameraTargetY = [tile getY]+CAMERA_ADD;
                    playerVY = 0;
                    jumpCount = 0;
                }
                break;
            case TILE_WALL_LEFT:
                playerVX = WALK_SPEED;
                break;
            case TILE_WALL_RIGHT:
                playerVX = -WALK_SPEED;
                break;
        }
    }
    
    // Update position
    playerX = playerX + playerVX;
    playerY = playerY + playerVY;
    
    // Update cameraVY
    if(isDead) {
        cameraVY += GRAVITY;
        if(cameraVY < CAMERA_MAX_SPEED_FALL) {
            cameraVY = CAMERA_MAX_SPEED_FALL;
        }
    } else {
        float camSpeed = 0.1;
        float cameraWillHitY;
        if(cameraVY > 0)
            cameraWillHitY = cameraY + cameraVY*((cameraVY/camSpeed)+1)/2.0;
        else
            cameraWillHitY = cameraY - cameraVY*((cameraVY/camSpeed)+1)/2.0;
        if(fabs(cameraY-cameraTargetY) < 2) {
            cameraVY = 0;
            cameraY = cameraTargetY;
        } else if(cameraWillHitY>cameraTargetY) {
            cameraVY -= camSpeed;
        } else if(cameraWillHitY<cameraTargetY) {
            cameraVY += camSpeed;
        }
    }

    // Update cameraY
    cameraY += cameraVY;
    if(cameraY < currentBaseFloor+CAMERA_ADD) {
        cameraY = cameraTargetY;
        cameraVY = 0;
    }

}

-(void) draw {
    float bgz = 2;
    float bgx = floor(cameraX/bgz/256.0)*256.0;
    float bgy = floor(cameraY/bgz/256.0)*256.0;
    for(int i=-3;i<=3;i++) for(int j=-3;j<=3;j++) {
        [sprites[SPRITE_BACKGROUND] drawWithX:bgx+i*256 y:bgy+j*256 z:bgz flip:false];
    }
    
    float fadeLimit = cameraY-DEATH_LIMIT;
    if(isDead)
        fadeLimit = playerY+64;
    [level drawWithFadeLimit:fadeLimit];
    [self drawPlayer];
}

-(void) drawPlayer {
    if(isDead) {
        [sprites[SPRITE_PLAYER_DEAD_0+(frameNum/10)%2] drawWithX:playerX y:playerY flip:playerVX<0];
    } else if(jumpCount == 2) {
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
    if(jumpCount == 0 && playerVY > JUMP_SLACK && !isDead) {
        playerVY = JUMP_SPEED;
        jumpCount++;
    } else if(jumpCount == 1 && !isDead) {
        playerVY = JUMP_SPEED;
        playerVX *= -1;
        jumpCount++;
    }
}
@end
