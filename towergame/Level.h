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
- (NSArray*) getNearbyTilesWithX:(float) centerX y:(float) centerY;
- (void) drawWithFadeLimit:(float) fadeLimit;
@end
