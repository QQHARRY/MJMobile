//
//  petitionAgreementViewController.h
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "petitionDetail.h"

@interface petitionAgreementViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *historyNodeTableView;
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *disAgreeBtn;
@property (strong, nonatomic) IBOutlet UILabel *opinionLabel;
@property (strong, nonatomic) IBOutlet UITextView *opinionForAgreement;
- (IBAction)agreeBtnClicked:(id)sender;
- (IBAction)disAgreeBtnClicked:(id)sender;

@property(strong,nonatomic)petitionDetail*petition;

@end
