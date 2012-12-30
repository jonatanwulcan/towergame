//
//  Game.m
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-27.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

#import "common.h"

#import "Game.h"
#import "Sprite.h"

@implementation Game

-(id) init {    
    self = [super init];
    level = [[Level alloc] initWithLevelNumber:0];
    return self;
}

-(void) update {
    
}

-(void) draw {
    [level draw];
}
@end
