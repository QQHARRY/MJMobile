//
//  sendMessageViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "sendMessageViewController.h"
#import "ContactListTableViewController.h"
#import "AppDelegate.h"
#import "person.h"
#import "UtilFun.h"
#import "messageManager.h"
#import "unit.h"
#import "department.h"

@interface sendMessageViewController ()

@end

@implementation sendMessageViewController



@synthesize bccFieldTitle;
@synthesize receiverNameList;
@synthesize ccNameList;
@synthesize bccNameList;
@synthesize msgTitleCtrl;

@synthesize strReceiverArr;
@synthesize strCCArr;
@synthesize strBCCArr;

@synthesize receiverArr;
@synthesize ccArr;
@synthesize bccArr;

@synthesize msgObj;
@synthesize selectType;

@synthesize dirtyFlag_receiver_changed;
@synthesize dirtyFlag_cc_changed;
@synthesize dirtyFlag_bcc_changed;

@synthesize msgType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMsg:)];
    
        // Do any additional setup after loading the view from its nib.
    self.receiverArr = [[NSMutableArray alloc] init];
    self.ccArr = [[NSMutableArray alloc] init];
    self.bccArr = [[NSMutableArray alloc] init];
    
    self.strReceiverArr = @"";
    self.strCCArr = @"";
    self.strBCCArr = @"";
    dirtyFlag_bcc_changed = NO;
    dirtyFlag_cc_changed = NO;
    dirtyFlag_receiver_changed = NO;
    [self initBottomNav];
    [self initWebView];
    
    [self initUIWithMessage:self.msgObj WithSendType:self.msgType];
}

-(void)initUIWithMessage:(messageObj*)obj WithSendType:(MJMESSAGESENDTYPE)type
{
    if (obj)
    {
        switch (type)
        {
            case MJMESSAGESENDTYPE_SEND:
            {
                
            }
                break;
            case MJMESSAGESENDTYPE_REPLY_SINGLE:
            {
                NSString*tmp = @"回复:";
                receiverNameList.text = obj.view_user_list_name;
                if (![obj.msg_title isEqualToString:@""])
                {
                    tmp = [tmp stringByAppendingString:obj.msg_title];
                }
                msgTitleCtrl.text = tmp;
                
                strReceiverArr = obj.view_user_list;
                
                
                ccNameList.text = @"";
                bccNameList.text = @"";
            }
                break;
            case MJMESSAGESENDTYPE_REPLY_ALL:
            {
                NSString*tmp = @"回复:";
                if (![obj.msg_title isEqualToString:@""]) {
                    tmp = [tmp stringByAppendingString:obj.msg_title];
                }
                msgTitleCtrl.text = tmp;
                
                
                receiverNameList.text = obj.view_user_list_name;
                if ([obj.msg_opt_user_list isEqualToString:@""])
                {
                    self.strReceiverArr = obj.view_user_list;
                }
                else
                {
                    self.strReceiverArr = [obj.view_user_list stringByAppendingString:@";"];
                    self.strReceiverArr = [self.strReceiverArr stringByAppendingString:obj.msg_opt_user_list];
                }
                

                NSString*strSenderList = obj.view_user_list_name;
                NSString*strRcvList = obj.msg_opt_user_list_name;
                if (![strRcvList isEqualToString:@""])
                {
                    strSenderList = [strSenderList stringByAppendingString:@";"];
                }
                strSenderList = [strSenderList stringByAppendingString:strRcvList];
                receiverNameList.text = strSenderList;
                
                
                
                ccNameList.text = obj.msg_cc_user_list_name;
                self.strCCArr = obj.msg_cc_user_list;

                bccNameList.text = obj.msg_bcc_user_list_name;
                self.strBCCArr = obj.mg_bcc_user_list;

            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    if (type == MJMESSAGESENDTYPE_REPLY_SINGLE || type == MJMESSAGESENDTYPE_REPLY_ALL)
    {
        self.bccFieldTitle.hidden = YES;
        self.bccNameList.hidden = YES;
        self.bccSelectBtn.hidden = YES;
    }
}

-(void)initWebView
{
    
    _webView.layer.cornerRadius=3;
    _webView.layer.masksToBounds=YES;
    _webView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _webView.layer.borderWidth= 1.0f;
    
    

    [_webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"]]];
}

-(void)viewDidAppear:(BOOL)animated
{
    _webViewOldFrame = _webView.frame;
}

-(void)initBottomNav
{
    self.bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, self.webView.frame.size.height+self.webView.frame.origin.y, self.webView.frame.size.width, 44)];
    UINavigationItem *bottomItem = [[UINavigationItem alloc] init];

    UIBarButtonItem *colorButton = [[UIBarButtonItem alloc] initWithTitle:@"字色" style:UIBarButtonItemStyleBordered target:self action:@selector(changeColor)];
    UIBarButtonItem *boldButton = [[UIBarButtonItem alloc] initWithTitle:@"粗体" style:UIBarButtonItemStyleBordered target:self action:@selector(changeBold)];
    UIBarButtonItem *italicButton = [[UIBarButtonItem alloc] initWithTitle:@"斜体" style:UIBarButtonItemStyleBordered target:self action:@selector(changeItalic)];
    bottomItem.leftBarButtonItems = @[colorButton,boldButton,italicButton];
    _bottomBar.items = @[bottomItem];
    _bottomBar.hidden = YES;
    [self.view addSubview:_bottomBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendMsg:(id)sender
{
    NSString* strTmpReceiver = self.receiverNameList.text;
    if ([[strTmpReceiver stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        PRSENTALERT(@"收件人不能为空",@"请选择收件人",@"OK",self);
        return;

    }
    
    messageObj*newMsg = [[messageObj alloc] init];
    
    if (dirtyFlag_receiver_changed)
    {
        newMsg.msg_opt_user_list = [self personArrIDToString:self.receiverArr];
    }
    else
    {
        newMsg.msg_opt_user_list = self.strReceiverArr;
    }
    
    if (dirtyFlag_cc_changed)
    {
        newMsg.msg_cc_user_list = [self personArrIDToString:self.ccArr];
    }
    else
    {
        newMsg.msg_cc_user_list = self.strCCArr;
    }
    
    if (dirtyFlag_bcc_changed)
    {
        newMsg.mg_bcc_user_list = [self personArrIDToString:self.bccArr];
    }
    else
    {
        newMsg.mg_bcc_user_list = self.strBCCArr;
    }
    
    newMsg.msg_title = self.msgTitleCtrl.text;
    
    
    newMsg.msg_content = [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    
    SHOWHUD(self.view);
    [messageManager sendMessage:newMsg Success:^(id responseObject)
     {
         HIDEHUD(self.view);
         PRSENTALERT(@"发送成功",@"",@"OK",self);
         
         
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
        PRSENTALERT(@"发送失败",@"请重复",@"OK",self);
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"发送成功"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - 键盘的处理

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    float keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    [_webView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-keyboardHeight-44)];
    _bottomBar.hidden = NO;
    
    [_bottomBar setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight-44, self.view.frame.size.width, 44)];
    [UIView commitAnimations];
}

- (void)keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [_webView setFrame:_webViewOldFrame];
    _bottomBar.hidden = YES;
    //[_bottomBar setFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    [UIView commitAnimations];
}

#pragma mark - 自定义按钮事件


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('foreColor', false, '#FF0000')"];
            break;
            
        case 1:
            [_webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('foreColor', false, '#008000')"];
            break;
            
        case 2:
            [_webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('foreColor', false, '#0000FF')"];
            break;
            
        default:
            [_webView stringByEvaluatingJavaScriptFromString:@"document.execCommand('foreColor', false, '#000000')"];
            break;
    }
}

- (void)changeColor
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择字色" delegate:self cancelButtonTitle:@"黑色" destructiveButtonTitle:nil otherButtonTitles:@"红色",@"绿色",@"蓝色",nil];
    [sheet showInView:self.view];
}

- (void)changeBold
{
    [_webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Bold\")"];
}

- (void)changeItalic
{
    [_webView stringByEvaluatingJavaScriptFromString:@"document.execCommand(\"Italic\")"];
}


-(NSString*)personArrNameToString:(NSArray*)arr
{
    NSString*str = @"";
    
    if (arr)
    {
        int i = 0;
        for (unit* obj in arr)
        {
            if (i >0)
            {
                str = [str stringByAppendingString:@";"];
            }
            if ([obj isKindOfClass:[person class]])
            {
                str = [str stringByAppendingString:((person*)obj).name_full];
            }
            else if([obj isKindOfClass:[department class]])
            {
                str = [str stringByAppendingString:((department*)obj).dept_name];
            }
            
            i++;
        }
    }
    
    return str;
}

-(NSString*)personArrIDToString:(NSArray*)arr
{
    NSString*str = @"";
    
    
    
    if (arr)
    {
        int i = 0;
        for (unit* obj in arr)
        {
            if (i >0)
            {
                str = [str stringByAppendingString:@";"];
            }
            if ([obj isKindOfClass:[person class]])
            {
                str = [str stringByAppendingString:((person*)obj).job_no];
            }
            else if([obj isKindOfClass:[department class]])
            {
                str = [str stringByAppendingString:((department*)obj).dept_current_no];
            }
            
            i++;
        }
    }
    
    return str;
}


-(void)returnSelection:(NSArray*)curSelection
{
    switch (self.selectType)
    {
        case MJSELECTPERSONTYPE_RECEIVER:
        {
            self.dirtyFlag_receiver_changed = YES;
            [self.receiverArr removeAllObjects];
            [self.receiverArr addObjectsFromArray:curSelection];
            self.receiverNameList.text = [self personArrNameToString:self.receiverArr];
            
        }
            break;
        case MJSELECTPERSONTYPE_CC:
        {
            self.dirtyFlag_cc_changed = YES;
            [self.ccArr removeAllObjects];
            [self.ccArr addObjectsFromArray:curSelection];
            self.ccNameList.text = [self personArrNameToString:self.ccArr];
        }
            break;
        case MJSELECTPERSONTYPE_BCC:
        {
            self.dirtyFlag_bcc_changed = YES;
            [self.bccArr removeAllObjects];
            [self.bccArr addObjectsFromArray:curSelection];
            self.bccNameList.text = [self personArrNameToString:self.bccArr];
        }
            break;
        default:
            break;
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showContactVCWithSelectType:(MJSELECTPERSONTYPE)type
{
    self.selectType = type;
    AppDelegate*app = [[UIApplication sharedApplication] delegate];
    
    ContactListTableViewController*ctrl =[app instantiateViewControllerWithIdentifier:@"ContactListTableViewController" AndClass:[ContactListTableViewController class]];
    ctrl.selectMode = YES;
    ctrl.selectResultDelegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (IBAction)selectReceiveList:(id)sender
{
    [self showContactVCWithSelectType:MJSELECTPERSONTYPE_RECEIVER];
    
}

- (IBAction)selectCCList:(id)sender
{
    [self showContactVCWithSelectType:MJSELECTPERSONTYPE_CC];

}

- (IBAction)selectBCCList:(id)sender
{
    [self showContactVCWithSelectType:MJSELECTPERSONTYPE_RECEIVER];

}
@end
