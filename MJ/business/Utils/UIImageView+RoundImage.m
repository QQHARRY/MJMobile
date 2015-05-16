//
//  UIImageView+RoundImage.m
//  MJ
//
//  Created by harry on 15/4/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIImageView+RoundImage.h"
#import "UIImage+FX.h"

@implementation UIImageView(RoundImage)

-(void)setImageToRound:(UIImage *)image
{
//    CGFloat size = image.size.height > image.size.width?image.size.width:image.size.height;
//    UIImage*scaledImag = [image imageScaledToSize:CGSizeMake(size, size)];
//    UIImage*roundImage = [scaledImag imageWithCornerRadius:scaledImag.size.width];
//    [self setImage: roundImage];

    [self.layer setCornerRadius:self.frame.size.width/2.0];
    self.layer.masksToBounds = YES;
    //self.image = image;
    [self setNeedsLayout];
}

@end
