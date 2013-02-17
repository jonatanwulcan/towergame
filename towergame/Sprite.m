//
//  Sprite.m
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-23.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

#import "common.h"

#import "Sprite.h"

@implementation Sprite

-(id) initWithTextureX:(float) _textureX textureY:(float) _textureY width:(float) _width height:(float) _height flipX:(bool) _flipX rotation:(float) _rotation {
    self = [super init];
    textureX = _textureX;
    textureY = _textureY;
    width = _width;
    height = _height;
    rotation = _rotation;
    flipX = _flipX;
    return self;
}

-(void) drawWithX:(float) x y:(float) y z:(float) z flip:(bool) flip {
    if(fabs((x-cameraX)/z) > screenWidth+width || fabs((y-cameraY)/z) > screenHeight+height) {
        return;
    }
    
    float screenMin = MIN(screenWidth, screenHeight);
    float sx = screenMin/screenWidth/320.0;
    float sy = screenMin/screenHeight/320.0;
    
    float positionMatrix[] = {
        sx*width*2, 0, 0, 0,
        0, sy*height*2, 0, 0,
        0, 0, 1, 0,
        sx*(x-cameraX)/z, sy*(y-cameraY)/z, 0, 1,
    };
    glUniformMatrix4fv(uniforms[UNIFORM_POSITION_MATRIX], 1, 0, positionMatrix);
    
    float fx = (flipX^flip)?-1:1;
    float textureMatrix[] = {
        width/512.0*fx*cos(rotation), height/512.0*fx*sin(rotation), 0, 0,
        width/512.0*sin(rotation), -height/512.0*cos(rotation), 0, 0,
        0, 0, 1, 0,
        0.5+textureX/512.0, 0.5-textureY/512.0, 0, 1,
    };
    
    glUniformMatrix4fv(uniforms[UNIFORM_TEXTURE_MATRIX], 1, 0, textureMatrix);
    
    int texture = 0;
    if(y > 256+512*2) {
        texture = 1;
    }
    
    if(lastTexture != texture) {
        glUniform1i(uniforms[UNIFORM_TEXTURE], texture);
        lastTexture = texture;
    }
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}
@end
