//
//  YALSideMenuCell.m
//  YALMenuAnimation
//
//  Created by Maksym Lazebnyi on 1/12/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "ContextMenuCell.h"

@interface ContextMenuCell ()

@end

@implementation ContextMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.masksToBounds = YES;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowColor =[UIColor darkGrayColor].CGColor;//[[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1] CGColor];
    //self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 1;
    //self.menuImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.menuImageView.layer.borderWidth = 0.3;
    //self.menuImageView.layer.masksToBounds = YES;
    
//    self.menuImageView.layer.shadowOffset = CGSizeMake(0, 2);
//    self.menuImageView.layer.shadowColor =[UIColor blackColor].CGColor;
//    
//    self.menuImageView.layer.shadowOpacity = 1;
    
    
    
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImageView:)];
    [self.menuImageView addGestureRecognizer:gesture];
    
    self.contentView.transform = CGAffineTransformMakeScale (1,-1);
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.menuImageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.3
                                                      constant:0]];
}


-(void)tappedImageView:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapedOnImageView:)])
    {
        [self.delegate performSelector:@selector(didTapedOnImageView:) withObject:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - YALContextMenuCell

- (UIView*)animatedIcon {
    return self.menuImageView;
}

- (UIView *)animatedContent {
    return self.menuTitleLabel;
}

//-(void)layoutSubviews
//{
//    CGRect rct =  self.contentView.frame;
//    //[self.menuImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    self.menuImageView.frame = CGRectMake(self.contentView.frame.size.width*2.0f/3.0f, 0, self.contentView.frame.size.width/3.0f, self.contentView.frame.size.height);
//}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com