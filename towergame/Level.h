//
//  Level.h
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-27.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

@interface Level : NSObject {
    
}

- (id) initWithLevelNumber:(int) levelNumber;
- (void) drawWithFadeLimit:(float) fadeLimit;
- (int) round:(float) f;
- (int) tileTypeWithX:(int) fx y:(int) fy;
@end
