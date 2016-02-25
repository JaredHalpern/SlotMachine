//
//  UIImage+Slice.h
//  SlotMachine
//
//  Created by Jared Halpern on 2/24/16.
//  Copyright © 2016 byteMason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Slice)
- (NSMutableArray *)sliceImageIntoVerticalPieces:(NSInteger)numPieces;
@end