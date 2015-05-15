//
//  ContactPsnVCCellTableViewCell.m
//  MJ
//
//  Created by harry on 15/4/22.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContactPsnVCCellTableViewCell.h"

@implementation ContactPsnVCCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPerson:(person*)person
{
    self.psn = person;
    self.phoneBtn.hidden = !((self.psn.obj_mobile!=nil) && (self.psn.obj_mobile.length >0));
    self.msgBtn.hidden = !((self.psn.obj_mobile!=nil) && (self.psn.obj_mobile.length >0));
    IMSTATE imState = [self.psn imState];
    
    //self.psnImage.layer.cornerRadius = self.frame.size.width/2;
    
    
    switch (imState)
    {
        case IM_NOT_OPEN:
        {
            //[self.imBtn setBackgroundImage:[UIImage imageNamed:@"未开通icon"] forState:UIControlStateNormal];
            [self.imBtn setTitle:@"未开通" forState:UIControlStateNormal];
            [self.imBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.imBtn.enabled = NO;
        }
            break;
        case IM_OPENED_NOT_FRIEND:
        {
            [self.imBtn setBackgroundImage:[UIImage imageNamed:@"加好友icon"] forState:UIControlStateNormal];
            [self.imBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.imBtn setTitle:@"+好友" forState:UIControlStateNormal];
            self.imBtn.enabled = YES;
        }
            break;
        case IM_FRIEND:
        {
            [self.imBtn setBackgroundImage:[UIImage imageNamed:@"发消息icon"] forState:UIControlStateNormal];
            [self.imBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.imBtn setTitle:@"发消息" forState:UIControlStateNormal];
            self.imBtn.enabled = YES;
        }
            break;
        default:
        {
            //[self.imBtn setBackgroundImage:[UIImage imageNamed:@"未开通icon"] forState:UIControlStateNormal];
            [self.imBtn setTitle:@"未开通" forState:UIControlStateNormal];
            [self.imBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.imBtn.enabled = NO;
        }
            break;
    }
}

- (IBAction)smsBtnClicked:(id)sender {
    if (self.delegate)
    {
        [self.delegate smsBtnPressedOnCell:self];
    }
}

- (IBAction)phoneBtnClicked:(id)sender {
    if (self.delegate)
    {
        [self.delegate callBtnPressedOnCell:self];
    }
}

- (IBAction)imBtnClicked:(id)sender {
    if (self.delegate)
    {
        [self.delegate imBtnPressedOnCell:self];
    }
}
@end
