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
int lastTexture = -1;


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
    
    GLKTextureInfo* _texture0;
    GLKTextureInfo* _texture1;

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
            
    _texture0 = [GLKTextureLoader
                      textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jumptower0" ofType:@"png"]
                      options:nil
                      error: NULL];

    _texture1 = [GLKTextureLoader
                      textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jumptower1" ofType:@"png"]
                      options:nil
                      error: NULL];

    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(_texture0.target, _texture0.name);
    glTexParameteri(_texture0.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(_texture0.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(_texture1.target, _texture1.name);
    glTexParameteri(_texture1.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(_texture1.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    
    // Setup sprites
    sprites[SPRITE_FLOOR_0] = [[Sprite alloc] initWithTextureX:8.0 textureY:248.0 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_FLOOR_1] = [[Sprite alloc] initWithTextureX:8 textureY:248-16 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_FLOOR_2] = [[Sprite alloc] initWithTextureX:8+16 textureY:248-16 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_FLOOR_3] = [[Sprite alloc] initWithTextureX:8+32 textureY:248-16 width:16 height:16 flipX:false rotation:0];
    
    sprites[SPRITE_FLOOR_LEFT_0] = [[Sprite alloc] initWithTextureX:8+32 textureY:248 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_FLOOR_LEFT_1] = [[Sprite alloc] initWithTextureX:8 textureY:248-32 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_FLOOR_LEFT_2] = [[Sprite alloc] initWithTextureX:8+16 textureY:248-32 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_FLOOR_LEFT_3] = [[Sprite alloc] initWithTextureX:8+32 textureY:248-32 width:16 height:16 flipX:false rotation:0];
    
    sprites[SPRITE_FLOOR_RIGHT_0] = [[Sprite alloc] initWithTextureX:8+32 textureY:248 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_FLOOR_RIGHT_1] = [[Sprite alloc] initWithTextureX:8 textureY:248-32 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_FLOOR_RIGHT_2] = [[Sprite alloc] initWithTextureX:8+16 textureY:248-32 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_FLOOR_RIGHT_3] = [[Sprite alloc] initWithTextureX:8+32 textureY:248-32 width:16 height:16 flipX:true rotation:0];

    sprites[SPRITE_CORNER_LEFT_0] = [[Sprite alloc] initWithTextureX:8+48 textureY:248 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_CORNER_LEFT_1] = [[Sprite alloc] initWithTextureX:8 textureY:248-48 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_CORNER_LEFT_2] = [[Sprite alloc] initWithTextureX:8+16 textureY:248-48 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_CORNER_LEFT_3] = [[Sprite alloc] initWithTextureX:8+32 textureY:248-48 width:16 height:16 flipX:false rotation:0];

    sprites[SPRITE_CORNER_RIGHT_0] = [[Sprite alloc] initWithTextureX:8+48 textureY:248 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_CORNER_RIGHT_1] = [[Sprite alloc] initWithTextureX:8 textureY:248-48 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_CORNER_RIGHT_2] = [[Sprite alloc] initWithTextureX:8+16 textureY:248-48 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_CORNER_RIGHT_3] = [[Sprite alloc] initWithTextureX:8+32 textureY:248-48 width:16 height:16 flipX:true rotation:0];
    
    sprites[SPRITE_BACKGROUND] = [[Sprite alloc] initWithTextureX:192.0 textureY:192.0 width:128 height:128 flipX:false rotation:0];
    sprites[SPRITE_WALL_LEFT] = [[Sprite alloc] initWithTextureX:8.0+16 textureY:248.0 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_WALL_RIGHT] = [[Sprite alloc] initWithTextureX:8.0+16 textureY:248.0 width:16 height:16 flipX:true rotation:0];
    
    sprites[SPRITE_BASEFLOOR] = [[Sprite alloc] initWithTextureX:8.0+80 textureY:248.0 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_BASECORNER_LEFT] = [[Sprite alloc] initWithTextureX:8.0+80-16 textureY:248.0 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_BASECORNER_RIGHT] = [[Sprite alloc] initWithTextureX:8.0+80+16 textureY:248.0 width:16 height:16 flipX:false rotation:0];

    sprites[SPRITE_PLAYER_WALK_0] = [[Sprite alloc] initWithTextureX:-236.0+40*0 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_WALK_1] = [[Sprite alloc] initWithTextureX:-236.0+40*1 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_WALK_2] = [[Sprite alloc] initWithTextureX:-236.0+40*0 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_WALK_3] = [[Sprite alloc] initWithTextureX:-236.0+40*2 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_WALK_4] = [[Sprite alloc] initWithTextureX:-236.0+40*3 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_WALK_5] = [[Sprite alloc] initWithTextureX:-236.0+40*4 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_WALK_6] = [[Sprite alloc] initWithTextureX:-236.0+40*3 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_WALK_7] = [[Sprite alloc] initWithTextureX:-236.0+40*2 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    
    sprites[SPRITE_PLAYER_JUMP] = [[Sprite alloc] initWithTextureX:-236.0+40*5 textureY:236.0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_FALL] = [[Sprite alloc] initWithTextureX:-236.0+40*0 textureY:236.0-40 width:40 height:40 flipX:false rotation:0];
    
    sprites[SPRITE_PLAYER_PRIOUETTE_0] = [[Sprite alloc] initWithTextureX:-236.0+40*5 textureY:236.0-40*0 width:40 height:40 flipX:true rotation:0];
    sprites[SPRITE_PLAYER_PRIOUETTE_1] = [[Sprite alloc] initWithTextureX:-236.0+40*1 textureY:236.0-40*1 width:40 height:40 flipX:true rotation:0];
    sprites[SPRITE_PLAYER_PRIOUETTE_2] = [[Sprite alloc] initWithTextureX:-236.0+40*5 textureY:236.0-40*0 width:40 height:40 flipX:false rotation:0];
    sprites[SPRITE_PLAYER_PRIOUETTE_3] = [[Sprite alloc] initWithTextureX:-236.0+40*2 textureY:236.0-40*1 width:40 height:40 flipX:true rotation:0];

    sprites[SPRITE_PLAYER_DEAD_0] = [[Sprite alloc] initWithTextureX:-236.0+40*3 textureY:236.0-40*1 width:40 height:40 flipX:true rotation:0];
    sprites[SPRITE_PLAYER_DEAD_1] = [[Sprite alloc] initWithTextureX:-236.0+40*4 textureY:236.0-40*1 width:40 height:40 flipX:true rotation:0];
    
    sprites[SPRITE_SPIKE_RIGHT_0] = [[Sprite alloc] initWithTextureX:-8 textureY:248 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_SPIKE_RIGHT_1] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_SPIKE_RIGHT_2] = [[Sprite alloc] initWithTextureX:-8 textureY:216 width:16 height:16 flipX:false rotation:0];
    sprites[SPRITE_SPIKE_RIGHT_3] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:false rotation:0];
    
    sprites[SPRITE_SPIKE_LEFT_0] = [[Sprite alloc] initWithTextureX:-8 textureY:248 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_SPIKE_LEFT_1] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_SPIKE_LEFT_2] = [[Sprite alloc] initWithTextureX:-8 textureY:216 width:16 height:16 flipX:true rotation:0];
    sprites[SPRITE_SPIKE_LEFT_3] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:true rotation:0];

    sprites[SPRITE_SPIKE_UP_0] = [[Sprite alloc] initWithTextureX:-8 textureY:248 width:16 height:16 flipX:false rotation:M_PI/2];
    sprites[SPRITE_SPIKE_UP_1] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:false rotation:M_PI/2];
    sprites[SPRITE_SPIKE_UP_2] = [[Sprite alloc] initWithTextureX:-8 textureY:216 width:16 height:16 flipX:false rotation:M_PI/2];
    sprites[SPRITE_SPIKE_UP_3] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:false rotation:M_PI/2];

    sprites[SPRITE_SPIKE_DOWN_0] = [[Sprite alloc] initWithTextureX:-8 textureY:248 width:16 height:16 flipX:false rotation:-M_PI/2];
    sprites[SPRITE_SPIKE_DOWN_1] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:false rotation:-M_PI/2];
    sprites[SPRITE_SPIKE_DOWN_2] = [[Sprite alloc] initWithTextureX:-8 textureY:216 width:16 height:16 flipX:false rotation:-M_PI/2];
    sprites[SPRITE_SPIKE_DOWN_3] = [[Sprite alloc] initWithTextureX:-8 textureY:232 width:16 height:16 flipX:false rotation:-M_PI/2];

}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];

    GLuint name;
    name = _texture0.name;
    glDeleteTextures(1, &name);
    name = _texture1.name;
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
    float frameTime = 1.0/[self framesPerSecond];
    for(int i=0;i<([self timeSinceLastUpdate]-frameTime/2)/frameTime;i++) {
        [_game update];   
    }
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
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program);
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
    /*for(int i=0;i<100;i++) {
        [sprites[SPRITE_FLOOR_0] drawWithX:0 y:0 z:1 flip:false];
    }*/
    
    
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
