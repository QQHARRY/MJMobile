//
//  ContactPersonDetailsViewController.h
//  MJ
//
//  Created by harry on 15/4/23.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "person.h"




@interface ContactPersonDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *backGroundView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) IBOutlet UILabel *nameAndNo;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIToolbar *actionBar;


@property (assign, nonatomic) NSInteger keyBoardHeight;
@property (strong, nonatomic)person*psn;
- (IBAction)onBack:(id)sender;
@property(assign,nonatomic)BOOL editState;




@end
