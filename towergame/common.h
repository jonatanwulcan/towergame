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

enum
{
    ATTRIB_VERTEX,
    NUM_ATTRIBUTES
};

enum
{
    UNIFORM_POSITION_MATRIX,
    UNIFORM_TEXTURE_MATRIX,
    UNIFORM_TEXTURE,
    NUM_UNIFORMS
};

enum
{
    SPRITE_FLOOR,
    NUM_SPRITES
};


extern GLint uniforms[NUM_UNIFORMS];
extern float screenWidth;
extern float screenHeight;
extern float cameraX;
extern float cameraY;

@class Sprite;
extern Sprite* sprites[NUM_SPRITES];
