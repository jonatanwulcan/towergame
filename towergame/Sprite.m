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

-(id) initWithTextureX:(float) _textureX textureY:(float) _textureY width:(float) _width height:(float) _height flipX:(bool) _flipX {
    self = [super init];
    textureX = _textureX;
    textureY = _textureY;
    width = _width;
    height = _height;
    textureScaleX = _flipX?-1.0:1.0;
    return self;
}

-(void) drawWithX:(float) x y:(float) y z:(float) z flip:(bool) flip {
    if(fabs(x-cameraX) > 640+width*2 || fabs(y-cameraY) > 960+height*2) {
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
    
    float tsx = (flip?-1:1)*textureScaleX*width;
    float tsy = height;
    float textureMatrix[] = {
        tsx/512.0, 0, 0, 0,
        0, -tsy/512.0, 0, 0,
        0, 0, 1, 0,
        0.5+textureX/512.0, 0.5-textureY/512.0, 0, 1,
    };
    
    glUniformMatrix4fv(uniforms[UNIFORM_TEXTURE_MATRIX], 1, 0, textureMatrix);
    
    int texture = 0;
    if(y > 256+1024) {
        texture = 0;
    }
    
    if(lastTexture != texture) {
        glUniform1i(uniforms[UNIFORM_TEXTURE], texture);
        lastTexture = texture;
    }
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}
@end
