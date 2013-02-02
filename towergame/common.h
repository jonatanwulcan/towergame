//
//  common.h
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-23.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#include <mach/mach.h>
#include <mach/mach_time.h>
#include <unistd.h>

#define DEATH_LIMIT 368
#define CAMERA_ADD 160
#define GRAVITY -1.0
#define MAX_SPEED_FALL -8.0
#define WALK_SPEED 5.0
#define JUMP_SPEED 15.0
#define JUMP_SLACK -7.0
#define CAMERA_MAX_SPEED_FALL -32.0

enum {
    ATTRIB_VERTEX,
    NUM_ATTRIBUTES
};

enum {
    UNIFORM_POSITION_MATRIX,
    UNIFORM_TEXTURE_MATRIX,
    UNIFORM_TEXTURE,
    NUM_UNIFORMS
};

enum {
    SPRITE_FLOOR_0,
    SPRITE_FLOOR_1,
    SPRITE_FLOOR_2,
    SPRITE_FLOOR_3,
    
    SPRITE_FLOOR_LEFT_0,
    SPRITE_FLOOR_LEFT_1,
    SPRITE_FLOOR_LEFT_2,
    SPRITE_FLOOR_LEFT_3,
    
    SPRITE_FLOOR_RIGHT_0,
    SPRITE_FLOOR_RIGHT_1,
    SPRITE_FLOOR_RIGHT_2,
    SPRITE_FLOOR_RIGHT_3,
    
    SPRITE_BACKGROUND,
    SPRITE_WALL_LEFT,
    SPRITE_WALL_RIGHT,
    
    SPRITE_PLAYER_WALK_0,
    SPRITE_PLAYER_WALK_1,
    SPRITE_PLAYER_WALK_2,
    SPRITE_PLAYER_WALK_3,
    SPRITE_PLAYER_WALK_4,
    SPRITE_PLAYER_WALK_5,
    SPRITE_PLAYER_WALK_6,
    SPRITE_PLAYER_WALK_7,
    
    SPRITE_PLAYER_JUMP,
    SPRITE_PLAYER_FALL,
    
    SPRITE_PLAYER_PRIOUETTE_0,
    SPRITE_PLAYER_PRIOUETTE_1,
    SPRITE_PLAYER_PRIOUETTE_2,
    SPRITE_PLAYER_PRIOUETTE_3,
    
    SPRITE_PLAYER_DEAD_0,
    SPRITE_PLAYER_DEAD_1,
    NUM_SPRITES
};

enum {
    TILE_NONE,
    TILE_WALL_LEFT,
    TILE_WALL_RIGHT,
    TILE_BASEFLOOR,
    TILE_FLOOR,
    TILE_FLOOR_LEFT,
    TILE_FLOOR_RIGHT,
    NUM_TILES
};


extern GLint uniforms[NUM_UNIFORMS];
extern float screenWidth;
extern float screenHeight;
extern float cameraX;
extern float cameraY;
extern int lastTexture;

@class Sprite;
extern Sprite* sprites[NUM_SPRITES];
