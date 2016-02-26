//
//  GameScene.h
//  SlotMachine
//

//  Copyright (c) 2016 byteMason. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GameSceneDelegate <NSObject>

//- (void)

@end

@interface GameScene : SKScene
@property (nonatomic, weak) id <GameSceneDelegate> delegate;
@end
