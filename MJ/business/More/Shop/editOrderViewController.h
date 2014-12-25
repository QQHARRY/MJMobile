//
//  editOrderViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "order.h"


@protocol dataEdited <NSObject>

-(void)dataHasEditd;

@end

@interface editOrderViewController : UIViewController<UITextFieldDelegate>



@property(strong,nonatomic)order*odr;
@property(assign,nonatomic)id<dataEdited>delegate;


@property (strong, nonatomic) IBOutlet UILabel *storeNum;
@property (strong, nonatomic) IBOutlet UITextField *goodName;
@property (strong, nonatomic) IBOutlet UITextField *goodType;
@property (strong, nonatomic) IBOutlet UITextField *price;
@property (strong, nonatomic) IBOutlet UITextField *count;
@property (strong, nonatomic) IBOutlet UITextField *total;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) IBOutlet UITextField *editCount;

- (IBAction)editCountChanged:(id)sender;

- (IBAction)onCancelEdit:(id)sender;
- (IBAction)onSaveEdit:(id)sender;

@end
