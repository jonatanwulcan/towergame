//
//  Shader.fsh
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-09.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

uniform sampler2D texture;
varying lowp vec2 texCoords;

void main()
{
    gl_FragColor = texture2D(texture, texCoords);
}
