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

-(id) initWithTextureX:(float) _textureX textureY:(float) _textureY width:(float) _width height:(float) _height texture:(int) _texture flipX:(bool) _flipX {
    self = [super init];
    textureX = _textureX;
    textureY = _textureY;
    width = _width;
    height = _height;
    texture = _texture;
    textureScaleX = _flipX?-1.0:1.0;
    return self;
}

-(void) drawWithX:(float) x y:(float) y {
    [self drawWithX:x y:y z:1 flip:false];
}

-(void) drawWithX:(float) x y:(float) y flip:(bool) flip {
    [self drawWithX:x y:y z:1 flip:flip];
}

-(void) drawWithX:(float) x y:(float) y z:(float) z flip:(bool) flip {
    [self drawWithX:x y:y z:z flip:flip texture:texture];
}

-(void) drawWithX:(float) x y:(float) y z:(float) z flip:(bool) flip texture:(int) myTexture {
    float screenMin = MIN(screenWidth, screenHeight);
    
    GLKMatrix4 positionMatrix = GLKMatrix4MakeScale(screenMin/screenWidth/320.0, screenMin/screenHeight/320.0, 0);
    positionMatrix = GLKMatrix4Multiply(positionMatrix, GLKMatrix4MakeTranslation(x-cameraX/z, y-cameraY/z, 0));
    positionMatrix = GLKMatrix4Multiply(positionMatrix, GLKMatrix4MakeScale(width, height, 1));
    glUniformMatrix4fv(uniforms[UNIFORM_POSITION_MATRIX], 1, 0, positionMatrix.m);
    
    GLKMatrix4 textureMatrix = GLKMatrix4MakeTranslation(0.5, 0.5, 0);
    textureMatrix = GLKMatrix4Multiply(textureMatrix, GLKMatrix4MakeScale(1.0/512.0, -1.0/512.0, 0));
    
    textureMatrix = GLKMatrix4Multiply(textureMatrix, GLKMatrix4MakeTranslation(textureX, textureY, 0));
    textureMatrix = GLKMatrix4Multiply(textureMatrix, GLKMatrix4MakeScale((flip?-1:1)*textureScaleX*width, height, 0));
    
    glUniformMatrix4fv(uniforms[UNIFORM_TEXTURE_MATRIX], 1, 0, textureMatrix.m);
    
    glUniform1i(uniforms[UNIFORM_TEXTURE], myTexture);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}
@end
