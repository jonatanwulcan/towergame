//
//  Shader.vsh
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-09.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

attribute vec4 position;
varying vec2 texCoords;
uniform mat4 positionMatrix;
uniform mat4 textureMatrix;

void main()
{
    vec4 tt = textureMatrix * position;
    texCoords = vec2(tt[0], tt[1]);
    gl_Position = positionMatrix * position;
}
