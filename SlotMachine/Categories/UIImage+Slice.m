//
//  UIImage+Slice.m
//  SlotMachine
//
//  Created by Jared Halpern on 2/24/16.
//  Copyright © 2016 byteMason. All rights reserved.
//

#import "UIImage+Slice.h"

@implementation UIImage (Slice)

- (NSMutableArray *)sliceImageIntoVerticalPieces:(NSInteger)numPieces; {

    CGFloat imgWidth = self.size.width/numPieces;
    CGFloat imgheight = self.size.height;
    
    CGRect leftImgFrame = CGRectMake(0, 0, imgWidth, imgheight);
    CGRect rightImgFrame = CGRectMake(imgWidth, 0, imgWidth, imgheight);
    
    CGImageRef left = CGImageCreateWithImageInRect(self.CGImage, leftImgFrame);
    CGImageRef right = CGImageCreateWithImageInRect(self.CGImage, rightImgFrame);
    
    UIImage *leftImage = [UIImage imageWithCGImage:left];
    UIImage *rightImage = [UIImage imageWithCGImage:right];
    
    NSMutableArray *slicesArray = [@[] mutableCopy];
    [slicesArray addObject:leftImage];
    [slicesArray addObject:rightImage];
    
    CGImageRelease(left);
    CGImageRelease(right);
    
    return slicesArray;
}

@end
