//
//  ContactPsnVCCellTableViewCell.h
//  MJ
//
//  Created by harry on 15/4/22.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "person.h"

@class ContactPsnVCCellTableViewCell;

@protocol ContactPsnCellDelegate <NSObject>



@required

-(void)callBtnPressedOnCell:(ContactPsnVCCellTableViewCell*)cell;
-(void)imBtnPressedOnCell:(ContactPsnVCCellTableViewCell*)cell;
-(void)smsBtnPressedOnCell:(ContactPsnVCCellTableViewCell*)cell;

@end


@interface ContactPsnVCCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *psnImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *msgBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *imBtn;

@property (weak,nonatomic)person*psn;
@property (weak,nonatomic)id<ContactPsnCellDelegate>delegate;


- (void)setPerson:(person*)person;
- (IBAction)smsBtnClicked:(id)sender;
- (IBAction)phoneBtnClicked:(id)sender;
- (IBAction)imBtnClicked:(id)sender;






@end


























