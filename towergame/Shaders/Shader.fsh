//
//  Shader.fsh
//  towergame
//
//  Created by Jonatan Wulcan on 2012-12-30.
//  Copyright (c) 2012 Jonatan Wulcan. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
