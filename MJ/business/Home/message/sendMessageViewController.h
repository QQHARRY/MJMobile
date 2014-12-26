//
//  sendMessageViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageObj.h"
#import "ContactListTableViewController.h"


typedef NS_ENUM(NSInteger, MJSELECTPERSONTYPE) {
    MJSELECTPERSONTYPE_RECEIVER,
    MJSELECTPERSONTYPE_CC,
    MJSELECTPERSONTYPE_BCC
};

typedef NS_ENUM(NSInteger, MJMESSAGESENDTYPE) {
    MJMESSAGESENDTYPE_SEND,
    MJMESSAGESENDTYPE_REPLY_SINGLE,
    MJMESSAGESENDTYPE_REPLY_ALL
};

@interface sendMessageViewController : UIViewController<UIActionSheetDelegate,contacSelection,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UINavigationBar *bottomBar;

- (IBAction)selectReceiveList:(id)sender;
- (IBAction)selectCCList:(id)sender;
- (IBAction)selectBCCList:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *bccFieldTitle;
@property (strong, nonatomic) IBOutlet UIButton *bccSelectBtn;
@property (strong, nonatomic) IBOutlet UITextField *receiverNameList;
@property (strong, nonatomic) IBOutlet UITextField *ccNameList;
@property (strong, nonatomic) IBOutlet UITextField *bccNameList;
@property (strong, nonatomic) IBOutlet UITextField *msgTitleCtrl;

@property (nonatomic, strong) NSString*strReceiverArr;
@property (nonatomic, strong) NSString*strCCArr;
@property (nonatomic, strong) NSString*strBCCArr;

@property (nonatomic, strong) NSMutableArray*receiverArr;
@property (nonatomic, strong) NSMutableArray*ccArr;
@property (nonatomic, strong) NSMutableArray*bccArr;

@property (nonatomic, strong) messageObj*msgObj;
@property (nonatomic, assign) MJSELECTPERSONTYPE selectType;

@property (nonatomic, assign) BOOL dirtyFlag_receiver_changed;
@property (nonatomic, assign) BOOL dirtyFlag_cc_changed;
@property (nonatomic, assign) BOOL dirtyFlag_bcc_changed;

@property (nonatomic, assign)CGRect webViewOldFrame;


@property (nonatomic,assign)MJMESSAGESENDTYPE msgType;
@end
