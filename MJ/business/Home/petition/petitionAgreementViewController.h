//
//  petitionAgreementViewController.h
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "petitionDetail.h"
#import "chooseAssistDeptTableViewController.h"

@interface petitionAgreementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SelectionDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *historyNodeTableView;
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *disAgreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *opinionLabel;
@property (strong, nonatomic) IBOutlet UITextView *opinionForAgreement;
- (IBAction)agreeBtnClicked:(id)sender;
- (IBAction)disAgreeBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;

@property(strong,nonatomic)petitionDetail*petition;
@property(strong,nonatomic)NSString*petitionTaskID;
@property(strong,nonatomic)NSArray*selectedAssistDepts;

@end
