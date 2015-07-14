//
//  SectionValueCustomizedCell.h
//  MJ
//
//  Created by harry on 15/5/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "myTextFieldDelegate.h"

@interface SectionValueCustomizedCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *minValue;
@property (strong, nonatomic) IBOutlet UITextField *maxValue;
@property (weak,nonatomic)id<myTextFieldDelegate>textFieldDelegate;

-(void)setKeyBoardType:(UIKeyboardType)kbType;
@end
