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
@property (nonatomic)         CGFloat           timeDecayRate;
@property (nonatomic, strong) NSMutableArray    *slotSpeeds;
@property (nonatomic, strong) NSMutableArray    *slotSpriteNodes;
@property (nonatomic)         BOOL              slotsDoneSpinning;
@end

static const NSInteger slowestSpinSpeed = -4.0f;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.slotSpriteNodes = [@[] mutableCopy];

    NSInteger numSlots = 2;
    
    [self setupSpinForNumSlots:numSlots];
    
    //1080 x 1350 = 0.80
    UIImage *mainImage = [UIImage imageNamed:@"drewandinewyears2016.jpg"];
    NSMutableArray *imagePieces = [mainImage sliceImageIntoVerticalPieces:numSlots]; // only supports two at the moment
    
    NSInteger startingX = self.view.bounds.size.width/4; //0.0;
    
    for (UIImage *singleImage in imagePieces) {
        
        SKEffectNode *effectNode = [SKEffectNode node];
        [effectNode setShouldEnableEffects:NO];
        CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputRadius", @1.0f, nil];
        effectNode.filter = blur;
        effectNode.shouldRasterize = YES; // cache
//        effectNode.shouldEnableEffects = YES;
        
        SKTexture *imageTexture = [SKTexture textureWithImage:singleImage];
        self.spriteNode = [SKSpriteNode spriteNodeWithTexture:imageTexture];
        self.spriteNode.anchorPoint = CGPointZero;
        self.spriteNode.position = CGPointMake(startingX, 300);
        self.spriteNode.xScale = 0.20;
        self.spriteNode.yScale = 0.25;
        self.spriteNode.name = @"slot";
        
        [self.slotSpriteNodes addObject:self.spriteNode];
        [effectNode addChild:self.spriteNode];
        [self addChild:effectNode];
        startingX += self.spriteNode.size.width + 0.0;
    }
    NSLog(@"slot height: %f", self.spriteNode.size.height);
}

- (void)setupSpinForNumSlots:(NSInteger)numSlots {
    
    self.timeDecayRate = 0.99;
    self.slotsDoneSpinning = NO;
    self.slotSpeeds = [@[] mutableCopy];

    NSInteger num = 0;
    NSInteger lowerBound = 2800;
    NSInteger upperBound = 4200;
    
    // http://stackoverflow.com/a/24836267/885189
    for (NSInteger i = 0; i <= numSlots; i++) {
        num = lowerBound + ((float)arc4random() / UINT32_MAX) * (upperBound - lowerBound);
        [self.slotSpeeds addObject:[NSNumber numberWithFloat:-num]];
    }
}

- (void)moveSlots {
    
    NSInteger nodeNum = 0;

    for (SKSpriteNode *node in self.slotSpriteNodes) {
    
        SKSpriteNode *slotNode = (SKSpriteNode *)node;
        CGPoint slotVelocity = CGPointMake(0, ([self.slotSpeeds[nodeNum] integerValue]));
        CGPoint amtToMove = CGPointMake(slotVelocity.x, slotVelocity.y * self.timeDiff);
        
        self.slotSpeeds[nodeNum] = @(slotVelocity.y * self.timeDecayRate);
        
        if (amtToMove.y >= slowestSpinSpeed) { // when we start slowing down; ie: between -2.0 and 0.0
            
                NSLog(@"position.y %f", slotNode.position.y);
                amtToMove.y = slowestSpinSpeed;
        }
    
        // move slot
        slotNode.position = CGPointMake(slotNode.position.x, slotNode.position.y + amtToMove.y);
        
        // Checks if node is completely scrolled of the screen, if yes then put it at the top of the node
        if (slotNode.position.y <= -slotNode.size.height) {
            slotNode.position = CGPointMake(slotNode.position.x, slotNode.position.y + slotNode.size.height * 2);
            
        } else if (slotNode.position.y <= 0.5 && amtToMove.y == slowestSpinSpeed) {
            // otherwise slot is now at the lowest speed at which it will still move, and sliding one final loop until clicking into place
            // and stopping
            amtToMove.y = 0;
            slotNode.position = CGPointMake(slotNode.position.x, 0.0);
        }
        
        nodeNum++;
    
        if (nodeNum >= self.slotSpeeds.count) {
            nodeNum = 0;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {

    if (self.lastUpdateTime) {
        self.timeDiff = currentTime - self.lastUpdateTime;
    } else {
        self.timeDiff = 0;
    }
    
    self.lastUpdateTime = currentTime;
    
    if (!self.slotsDoneSpinning) {
        [self moveSlots];
    }
}

@end
