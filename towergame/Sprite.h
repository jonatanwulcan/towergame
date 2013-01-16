//
//  Sprite.h
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-23.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

@interface Sprite : NSObject {
    float textureX, textureY, width, height;
    int texture;
    float textureScaleX;
}

-(id) initWithTextureX:(float) _textureX textureY:(float) _textureY width:(float) _width height:(float) _height texture:(int) _texture flipX:(bool) _flipX;
-(void) drawWithX:(float) x y:(float) y;
-(void) drawWithX:(float) x y:(float) y flip:(bool) flip;
-(void) drawWithX:(float) x y:(float) y z:(float) z flip:(bool) flip;
-(void) drawWithX:(float) x y:(float) y z:(float) z flip:(bool) flip texture:(int) texture;
@end
