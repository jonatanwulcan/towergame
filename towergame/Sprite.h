//
//  Sprite.h
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-23.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

@interface Sprite : NSObject {
    float textureX, textureY, width, height;
    float textureScaleX;
}

-(id) initWithTextureX:(float) _textureX textureY:(float) _textureY width:(float) _width height:(float) _height flipX:(bool) _flipX;
-(void) drawWithX:(float) x y:(float) y z:(float) z flip:(bool) flip;
@end
