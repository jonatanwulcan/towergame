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
    currentBaseFloor = -32*LEVEL_OFFSET+32+16;
    cameraFall = false;

    return self;
}

-(void) update {
    frameNum++;
    
    // Is dead?
    if(!isDead && playerY < cameraTargetY-DEATH_LIMIT) {
        isDead = true;
    }
    
    if(isDead) {
        cameraFall = true;
        cameraTargetY = currentBaseFloor+CAMERA_ADD;        
    }
    
    if(isDead && playerY <= currentBaseFloor+32+32) {
        isDead = false;
    }
    if(!isDead && cameraFall && cameraY == cameraTargetY) {
        cameraFall = false;
    }
    
    // Gravity
    playerVY += GRAVITY;
    if(playerVY < MAX_SPEED_FALL) playerVY = MAX_SPEED_FALL;
    
    
    // Check collisions
    float newPlayerX = playerX + playerVX;
    float newPlayerY = playerY + playerVY;
    int cx = [level round:newPlayerX];
    int cy = [level round:newPlayerY];
    
    for(int y=cy-64;y<=cy+64;y+=32) {
        for(int x=cx-64;x<=cx+64;x+=32) {
            bool isColliding = fabs(newPlayerX-x) < 16+32/2 && fabs(newPlayerY-y) < 16+64/2;
            bool isCollidingBigHitbox = fabs(newPlayerX-x) < 16+32/2 && fabs(newPlayerY-y) < 16+96/2;
            bool isCollidingSmallHitbox = fabs(newPlayerX-x) < 32/2 && fabs(newPlayerY-y) < 64/2;
            bool isCollidingNoYMovement = fabs(newPlayerX-x) < 16+32/2 && fabs(playerY-y) < 16+64/2;

            if(!isCollidingBigHitbox) continue;
            
            switch([level tileTypeWithX:x y:y]) {
                case TILE_BASEFLOOR:
                    if(playerVY < 0 && !isCollidingNoYMovement && isColliding) {
                        playerY = y + 16 + 32;
                        if(y+CAMERA_ADD > cameraTargetY) cameraTargetY = y+CAMERA_ADD;
                        playerVY = 0;
                        jumpCount = 0;
                    }
                    if(playerY >= y+16+32) {
                        currentBaseFloor = cy;
                    }
                    break;
                case TILE_FLOOR:
                case TILE_FLOOR_LEFT:
                case TILE_FLOOR_RIGHT:
                    if(playerVY < 0 && !isCollidingNoYMovement && !isDead && y > cameraTargetY - DEATH_LIMIT &&isColliding) {
                        playerY = y + 16 + 32;
                        if(y+CAMERA_ADD > cameraTargetY) cameraTargetY = y+CAMERA_ADD;
                        playerVY = 0;
                        jumpCount = 0;
                    }
                    break;
                case TILE_CORNER_LEFT:
                case TILE_WALL_LEFT:
                    if(isColliding) {
                        playerVX = WALK_SPEED;
                    }
                    break;
                case TILE_CORNER_RIGHT:
                case TILE_WALL_RIGHT:
                    if(isColliding) {
                        playerVX = -WALK_SPEED;
                    }
                    break;
                case TILE_SPIKE_RIGHT:
                case TILE_SPIKE_LEFT:
                case TILE_SPIKE_UP:
                case TILE_SPIKE_DOWN:
                    if(isCollidingSmallHitbox) {
                        isDead = true;
                    }
                    break;
            }
        }
    }
    
    // Update position
    playerX = playerX + playerVX;
    playerY = playerY + playerVY;
    
    // Update cameraVY
    if(cameraFall) {
        cameraVY += GRAVITY;
        if(cameraVY < CAMERA_MAX_SPEED_FALL) {
            cameraVY = CAMERA_MAX_SPEED_FALL;
        }
        cameraY += cameraVY;
        if(cameraY < currentBaseFloor+CAMERA_ADD && cameraFall) {
            cameraY = cameraTargetY;
            cameraVY = 0;
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
        cameraY += cameraVY;
    }
}

-(void) draw {
    float bgz = 2;
    float bgx = floor(cameraX/512.0)*512.0;
    float bgy = floor(cameraY/512.0)*512.0;
    for(int j=4;j>=-4;j--) for(int i=-1;i<=1;i++) {
        [sprites[SPRITE_BACKGROUND] drawWithX:bgx+i*512 y:bgy+j*512 z:bgz flip:false];
    }
    
    float fadeLimit = cameraY-DEATH_LIMIT;
    if(isDead)
        fadeLimit = playerY+64;
    [level drawWithFadeLimit:fadeLimit baseFloor:currentBaseFloor frameNumber:frameNum];
    [self drawPlayer];
}

-(void) drawPlayer {
    if(isDead) {
        [sprites[SPRITE_PLAYER_DEAD_0+(frameNum/10)%2] drawWithX:playerX y:playerY z:1 flip:playerVX<0];
    } else if(jumpCount == 2) {
        [sprites[SPRITE_PLAYER_PRIOUETTE_0+(frameNum/5)%4] drawWithX:playerX y:playerY z:1 flip:playerVX<0];
    } else {
        if(fabs(playerVY) < 2) {
            [sprites[SPRITE_PLAYER_WALK_0+(frameNum/5)%8] drawWithX:playerX y:playerY z:1 flip:playerVX<0];
        } else if(playerVY > 0) {
            [sprites[SPRITE_PLAYER_JUMP] drawWithX:playerX y:playerY z:1 flip:playerVX<0];
        } else if(playerVY < 0) {
            [sprites[SPRITE_PLAYER_FALL] drawWithX:playerX y:playerY z:1 flip:playerVX<0];
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
