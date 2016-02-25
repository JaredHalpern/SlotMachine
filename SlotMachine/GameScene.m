//
//  GameScene.m
//  SlotMachine
//
//  Created by Jared Halpern on 2/24/16.
//  Copyright (c) 2016 byteMason. All rights reserved.
//

#import "GameScene.h"
#import "UIImage+Slice.h"

@interface GameScene ()
@property (nonatomic, strong) SKSpriteNode *spriteNode;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    //1080 x 1350 = 0.80
    UIImage *mainImage = [UIImage imageNamed:@"drewandinewyears2016.jpg"];
    NSMutableArray *imagePieces = [mainImage sliceImageIntoVerticalPieces:2]; // only supports two at the moment
    
    NSInteger startingX = 00.0;
    
    for (UIImage *singleImage in imagePieces) {
        
        SKTexture *imageTexture = [SKTexture textureWithImage:singleImage];
        self.spriteNode = [SKSpriteNode spriteNodeWithTexture:imageTexture];
        self.spriteNode.anchorPoint = CGPointMake(0., 0.);
        self.spriteNode.position = CGPointMake(startingX, 300);
//        self.spriteNode.size = CGSizeMake(240, 300);
        self.spriteNode.xScale = 0.20;
        self.spriteNode.yScale = 0.25;
        [self addChild:self.spriteNode];
        startingX += 240;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
