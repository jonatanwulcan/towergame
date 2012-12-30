//
//  Game.h
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-27.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

#import "Level.h"

@interface Game : NSObject {
    Level* level;
}

-(id) init;
-(void) update;
-(void) draw;
@end
