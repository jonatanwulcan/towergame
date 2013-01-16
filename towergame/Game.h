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
    int frameNum;
    float playerX;
    float playerY;
    float playerVX;
    float playerVY;
    float cameraTargetY;
    float cameraVY;
    int jumpCount;
    bool isDead;
    float currentBaseFloor;
}

-(id) init;
-(void) update;
-(void) draw;
-(void) drawPlayer;
-(void) jump;

@end
