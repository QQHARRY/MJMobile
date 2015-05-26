//
//  SingleValueCustomizedCell.h
//  MJ
//
//  Created by harry on 15/5/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "myTextFieldDelegate.h"

@interface SingleValueCustomizedCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UITextField *singleValueField;

@property (weak,nonatomic)id<myTextFieldDelegate>textFieldDelegate;


@end
