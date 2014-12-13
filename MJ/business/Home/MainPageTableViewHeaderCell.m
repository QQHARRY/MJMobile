//
//  MainPageTableViewHeaderCell.m
//  MJ
//
//  Created by harry on 14-12-6.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MainPageTableViewHeaderCell.h"

@implementation MainPageTableViewHeaderCell

- (void)awakeFromNib {
    // Initialization code
    self.action = nil;
    CGSize sz =  [UIScreen mainScreen].bounds.size;
    
    [self setFrame:CGRectMake(0, 0, sz.width,self.frame.size.height)];
    
//    [self.btn setFrame:CGRectMake(sz.width-self.btn.frame.size.width - 20, self.btn.frame.origin.y, self.btn.frame.size.width, self.btn.frame.size.height)];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (IBAction)btnClicked:(id)sender
{
    if (self.action)
    {
        self.action(sender);
    }
}

-(void)initWithTitle:(NSString*)title andAction:(void(^)(UIButton*))act
{
    CGRect rct = [self frame];
    [self.btn setFrame:CGRectMake(350, self.btn.frame.origin.y, self.btn.frame.size.width, self.btn.frame.size.height)];
    rct = [self.btn  frame];
    self.titleLab.text = title;
    self.action = act;
}
@end
