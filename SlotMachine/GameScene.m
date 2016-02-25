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
@property (nonatomic, strong) SKSpriteNode      *spriteNode;
@property (nonatomic)         CGFloat           timeDiff;
@property (nonatomic)         CFTimeInterval    lastUpdateTime;
@property (nonatomic, strong) NSMutableArray    *slotSpeeds;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.slotSpeeds = [@[] mutableCopy];
    
    //1080 x 1350 = 0.80
    UIImage *mainImage = [UIImage imageNamed:@"drewandinewyears2016.jpg"];
    NSMutableArray *imagePieces = [mainImage sliceImageIntoVerticalPieces:2]; // only supports two at the moment
    
    NSInteger num = 0;
    NSInteger lowerBound = 2800;
    NSInteger upperBound = 4200;
    // http://stackoverflow.com/a/24836267/885189
    for (NSInteger i = 0; i < imagePieces.count; i++) {
        num = lowerBound + ((float)arc4random() / UINT32_MAX) * (upperBound - lowerBound);
        [self.slotSpeeds addObject:[NSNumber numberWithFloat:num]];
    }
    
    NSLog(@"%@", self.slotSpeeds);
    
    NSInteger startingX = 0.0;
    
    for (UIImage *singleImage in imagePieces) {
        
        SKTexture *imageTexture = [SKTexture textureWithImage:singleImage];
        self.spriteNode = [SKSpriteNode spriteNodeWithTexture:imageTexture];
        self.spriteNode.anchorPoint = CGPointZero;
        self.spriteNode.position = CGPointMake(startingX, 300);
        self.spriteNode.xScale = 0.20;
        self.spriteNode.yScale = 0.25;
        self.spriteNode.name = @"slot";
        [self addChild:self.spriteNode];
        startingX += self.spriteNode.size.width + 8.0;
    }
}

- (void)moveSlots {
    
    __block NSInteger nodeNum = 0;
    __weak GameScene *welf = self;
    
    [self enumerateChildNodesWithName:@"slot" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {

        SKSpriteNode *slot = (SKSpriteNode *)node;
        CGPoint slotVelocity = CGPointMake(0, -([welf.slotSpeeds[nodeNum] integerValue]));
        CGPoint amtToMove = CGPointMake(slotVelocity.x * self.timeDiff, slotVelocity.y * self.timeDiff);
        slot.position = CGPointMake(slot.position.x + amtToMove.x, slot.position.y + amtToMove.y);
        
        //Checks if node is completely scrolled of the screen, if yes then put it at the top of the node
        if (slot.position.y <= -slot.size.height) {
            slot.position = CGPointMake(slot.position.x, slot.position.y + slot.size.height * 2);
        }
        
        nodeNum++;
        if (nodeNum >= welf.slotSpeeds.count) {
            nodeNum = 0;
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
        
//        [self beginSpin];
//    }
}

-(void)update:(CFTimeInterval)currentTime {

    if (self.lastUpdateTime) {
        self.timeDiff = currentTime - self.lastUpdateTime;
    } else {
        self.timeDiff = 0;
    }
    
    self.lastUpdateTime = currentTime;
    
    [self moveSlots];
}

@end
