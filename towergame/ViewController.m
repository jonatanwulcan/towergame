//
//  ViewController.m
//  wordgame
//
//  Created by Jonatan Wulcan on 2012-12-09.
//  Copyright (c) 2012 Wulcan Consulting. All rights reserved.
//

#import "common.h"

#import "ViewController.h"
#import "Sprite.h"
#import "Game.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Externs index.
GLint uniforms[NUM_UNIFORMS];
float screenWidth;
float screenHeight;
float cameraX = 0;
float cameraY = 0;


Sprite* sprites[NUM_SPRITES];

GLfloat vertexData[] =
{
    -0.5f, -0.5f, 0,
    0.5f, -0.5f, 0,
    -0.5f, 0.5f, 0,
    -0.5f, 0.5f, 0,
    0.5f, -0.5f, 0,
    0.5f, 0.5f, 0,
};

@interface ViewController () {
    GLuint _program;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    GLKTextureInfo* _textureActor;
    GLKTextureInfo* _textureLevel0;
    GLKTextureInfo* _textureLevel1;
    
    uint64_t _fpsTimer;
    int _fpsNumFrames;
    
    Game* _game;
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ViewController

@synthesize context = _context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.preferredFramesPerSecond = 60;

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    _fpsTimer = mach_absolute_time();
    _fpsNumFrames = 0;
    
    [self setupGL];
    
    _game = [[Game alloc] init];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    [EAGLContext setCurrentContext:nil];
	self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
        
    _textureActor = [GLKTextureLoader
                 textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jumptower_actors" ofType:@"png"]
                 options:nil
                 error: NULL];
    
    _textureLevel0 = [GLKTextureLoader
                 textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jumptower_level1" ofType:@"png"]
                 options:nil
                 error: NULL];

    _textureLevel1 = [GLKTextureLoader
                      textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jumptower_level2" ofType:@"png"]
                      options:nil
                      error: NULL];

    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(_textureActor.target, _textureActor.name);
    glTexParameteri(_textureActor.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(_textureActor.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(_textureLevel0.target, _textureLevel0.name);
    glTexParameteri(_textureLevel0.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(_textureLevel0.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(_textureLevel1.target, _textureLevel1.name);
    glTexParameteri(_textureLevel1.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(_textureLevel1.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    
    // Setup sprites
    sprites[SPRITE_FLOOR_0] = [[Sprite alloc] initWithTextureX:-240.0 textureY:240.0 width:32 height:32 texture:1 flipX:false];
    sprites[SPRITE_FLOOR_1] = [[Sprite alloc] initWithTextureX:-240.0 textureY:240.0-32 width:32 height:32 texture:1 flipX:false];
    sprites[SPRITE_FLOOR_2] = [[Sprite alloc] initWithTextureX:-240.0+32 textureY:240.0-32 width:32 height:32 texture:1 flipX:false];
    sprites[SPRITE_FLOOR_3] = [[Sprite alloc] initWithTextureX:-240.0+64 textureY:240.0-32 width:32 height:32 texture:1 flipX:false];


    sprites[SPRITE_FLOOR_LEFT_0] = [[Sprite alloc] initWithTextureX:-240.0+32*2 textureY:240 width:32 height:32 texture:1 flipX:false];
    sprites[SPRITE_FLOOR_LEFT_1] = [[Sprite alloc] initWithTextureX:-240.0+32*0 textureY:240-64 width:32 height:32 texture:1 flipX:false];
    sprites[SPRITE_FLOOR_LEFT_2] = [[Sprite alloc] initWithTextureX:-240.0+32*1 textureY:240-64 width:32 height:32 texture:1 flipX:false];
    sprites[SPRITE_FLOOR_LEFT_3] = [[Sprite alloc] initWithTextureX:-240.0+32*2 textureY:240-64 width:32 height:32 texture:1 flipX:false];

    sprites[SPRITE_FLOOR_RIGHT_0] = [[Sprite alloc] initWithTextureX:-240.0+32*2 textureY:240 width:32 height:32 texture:1 flipX:true];
    sprites[SPRITE_FLOOR_RIGHT_1] = [[Sprite alloc] initWithTextureX:-240.0+32*0 textureY:240-64 width:32 height:32 texture:1 flipX:true];
    sprites[SPRITE_FLOOR_RIGHT_2] = [[Sprite alloc] initWithTextureX:-240.0+32*1 textureY:240-64 width:32 height:32 texture:1 flipX:true];
    sprites[SPRITE_FLOOR_RIGHT_3] = [[Sprite alloc] initWithTextureX:-240.0+32*2 textureY:240-64 width:32 height:32 texture:1 flipX:true];

    
    sprites[SPRITE_BACKGROUND] = [[Sprite alloc] initWithTextureX:128.0 textureY:128.0 width:256 height:256 texture:1 flipX:false];
    sprites[SPRITE_WALL_LEFT] = [[Sprite alloc] initWithTextureX:-240.0+32 textureY:240.0 width:32 height:32 texture:1 flipX:false];
    sprites[SPRITE_WALL_RIGHT] = [[Sprite alloc] initWithTextureX:-240.0+32 textureY:240.0 width:32 height:32 texture:1 flipX:true];

    sprites[SPRITE_PLAYER_WALK_0] = [[Sprite alloc] initWithTextureX:-216.0+80*0 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_WALK_1] = [[Sprite alloc] initWithTextureX:-216.0+80*1 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_WALK_2] = [[Sprite alloc] initWithTextureX:-216.0+80*0 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_WALK_3] = [[Sprite alloc] initWithTextureX:-216.0+80*2 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_WALK_4] = [[Sprite alloc] initWithTextureX:-216.0+80*3 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_WALK_5] = [[Sprite alloc] initWithTextureX:-216.0+80*4 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_WALK_6] = [[Sprite alloc] initWithTextureX:-216.0+80*3 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_WALK_7] = [[Sprite alloc] initWithTextureX:-216.0+80*2 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    
    sprites[SPRITE_PLAYER_JUMP] = [[Sprite alloc] initWithTextureX:-216.0+80*5 textureY:216.0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_FALL] = [[Sprite alloc] initWithTextureX:-216.0+80*0 textureY:216.0-80 width:78 height:78 texture:0 flipX:false];
    
    sprites[SPRITE_PLAYER_PRIOUETTE_0] = [[Sprite alloc] initWithTextureX:-216.0+80*5 textureY:216.0-80*0 width:78 height:78 texture:0 flipX:true];
    sprites[SPRITE_PLAYER_PRIOUETTE_1] = [[Sprite alloc] initWithTextureX:-216.0+80*1 textureY:216.0-80*1 width:78 height:78 texture:0 flipX:true];
    sprites[SPRITE_PLAYER_PRIOUETTE_2] = [[Sprite alloc] initWithTextureX:-216.0+80*5 textureY:216.0-80*0 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_PRIOUETTE_3] = [[Sprite alloc] initWithTextureX:-216.0+80*2 textureY:216.0-80*1 width:78 height:78 texture:0 flipX:true];

    sprites[SPRITE_PLAYER_DEAD_0] = [[Sprite alloc] initWithTextureX:-216.0+80*3 textureY:216.0-80*1 width:78 height:78 texture:0 flipX:false];
    sprites[SPRITE_PLAYER_DEAD_1] = [[Sprite alloc] initWithTextureX:-216.0+80*4 textureY:216.0-80*1 width:78 height:78 texture:0 flipX:false];


}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    GLuint name = _textureActor.name;
    glDeleteTextures(1, &name);
    name = _textureLevel0.name;
    glDeleteTextures(1, &name);
    name = _textureLevel1.name;
    glDeleteTextures(1, &name);

    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
        
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    [_game update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Check fps
    _fpsNumFrames++;
    uint64_t elapsed = mach_absolute_time() - _fpsTimer;
    mach_timebase_info_data_t sTimebaseInfo;
    mach_timebase_info(&sTimebaseInfo);
    uint64_t ms = elapsed * sTimebaseInfo.numer / sTimebaseInfo.denom/1000/1000;
    if(ms > 1000) {
        NSLog(@"fps: %d", _fpsNumFrames);
        _fpsTimer = mach_absolute_time();
        _fpsNumFrames = 0;
    }
    
    // Draw
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program);
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
    [_game draw];
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_POSITION_MATRIX] = glGetUniformLocation(_program, "positionMatrix");
    uniforms[UNIFORM_TEXTURE_MATRIX] = glGetUniformLocation(_program, "textureMatrix");
    uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(_program, "texture");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_game jump];
}

@end
