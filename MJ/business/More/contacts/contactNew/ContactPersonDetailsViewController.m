//
//  ContactPersonDetailsViewController.m
//  MJ
//
//  Created by harry on 15/4/23.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContactPersonDetailsViewController.h"
#import "ContacCustomizedBarBtnItemView.h"
#import "ContactPersonDetailsVCTableViewCell.h"
#import "UIImage+FX.h"
#import "UITableView+AutoMoveCovered.h"
#import "UtilFun.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "RestPassWordViewController.h"


#define BEIJINGIMAGE @"背景图片"
#define WEIKAITONGIMAGE @"未开通new"
#define DADIANHUAIMAGE @"打电话new"
#define FADUANXINIMAGE @"发信息new"
#define XIUGAIZILIAOIMAGE @"修改资料new"
#define XIUGAIWANCHENGIMAGE @"修改完成new"
#define XIUGAIMIMAIMAGE @"修改密码new"

#define GONGSIIMAGE @"公司icon"
#define BUMENIMAGE @"个人详情部门icon"
#define ZHIWEIIMAGE @"职位icon"
#define DIANHUAIMAGE @"电话号码前icon"
#define QIANMINGIMAGE @"签名icon"
#define JIANJIEIMAGE @"简介icon"




#define GONGSI @"公司:"
#define BUMEN  @"部门:"
#define ZHIWEI @"职位:"
#define DIANHUA @"电话:"
#define QIANMING @"签名:"
#define JIANJIE @"简介:"

@interface ContactPersonDetailsViewController ()


@property(strong,nonatomic)ContactPersonDetailsVCTableViewCell*cellPhoneNum;
@property(strong,nonatomic)ContactPersonDetailsVCTableViewCell*cellSign;
@property(strong,nonatomic)ContactPersonDetailsVCTableViewCell*cellContent;
@end

@implementation ContactPersonDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [self.tableview setContentSize:self.view.frame.size];
    
    
    self.editState = NO;
    self.nameAndNo.text = [NSString stringWithFormat:@"%@ %@",self.psn.name_full,self.psn.job_no];

    
    
    [self setActionBarItems];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 22;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44;
    }
    else
    {
        if (indexPath.row <4)
        {
            return 44;
        }
        else if(indexPath.row == 4)
        {
            return 88;
        }
    }
    
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ContactPersonDetailsVCTableViewCell";
    ContactPersonDetailsVCTableViewCell *cell = nil;
    if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ContactPersonDetailsVCTableViewCell class]])
            {
                cell = (ContactPersonDetailsVCTableViewCell *)oneObject;
            }
        }
    };
    cell.value.tag = indexPath.section*100+indexPath.row;
    cell.value.delegate = self;
    [cell setEditAble:self.editState];
    
    if (indexPath.section == 0)
    {
        cell.type.text = DIANHUA;
        cell.typeImage.image = [UIImage imageNamed:DIANHUAIMAGE];
        cell.value.text = self.psn.obj_mobile;
        self.cellPhoneNum = cell;
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.typeImage.image = [UIImage imageNamed:GONGSIIMAGE];
                cell.type.text = GONGSI;
                cell.value.text = self.psn.company_name;
                [cell setEditAble:NO];
            }
                break;
            case 1:
            {
                cell.typeImage.image = [UIImage imageNamed:BUMENIMAGE];
                cell.type.text = BUMEN;
                if([self.psn isEqual:[person me]])
                {
                    cell.value.text = self.psn.department_name;
                }
                else
                {
                    cell.value.text = self.psn.dept_name;
                }
                
                [cell setEditAble:NO];
            }
                break;
            case 2:
            {
                cell.typeImage.image = [UIImage imageNamed:ZHIWEIIMAGE];
                cell.type.text = ZHIWEI;
                cell.value.text = self.psn.job_name;
                [cell setEditAble:NO];
            }
                break;
            case 3:
            {
                cell.typeImage.image = [UIImage imageNamed:QIANMINGIMAGE];
                cell.type.text = QIANMING;
                cell.value.text = self.psn.acc_remarks;
                self.cellSign = cell;
            }
                break;
            case 4:
            {
                cell.typeImage.image = [UIImage imageNamed:JIANJIEIMAGE];
                cell.type.text = JIANJIE;
                cell.value.text = self.psn.acc_content;
                self.cellContent = cell;
            }
                break;
                
            default:
                break;
        }
    
    }

    return cell;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 键盘的处理
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = NO;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    [super viewWillDisappear:animated];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.keyBoardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations:@"scrollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.1f];
    self.view.frame = CGRectMake(0 , 0-self.keyBoardHeight+44, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide
{
    self.keyBoardHeight = 0;
    [UIView beginAnimations:@"scrollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.1f];
    self.view.frame = CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


-(void)setActionBarItems
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    if ([self.psn isEqual:[person me]])
    {
        if (self.editState)
        {
            UIBarButtonItem* edtBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onCommitEdit)];
            [edtBtn setImage:[UIImage imageNamed:XIUGAIWANCHENGIMAGE]];
            
            
            UIBarButtonItem* resetPwdBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onBeginReSetPwd)];
            [resetPwdBtn setImage:[UIImage imageNamed:XIUGAIMIMAIMAGE]];
            
            
            
            [items addObjectsFromArray:[NSArray arrayWithObjects:flexSpace,resetPwdBtn,flexSpace,edtBtn,flexSpace, nil]];
        }
        else
        {
            UIBarButtonItem* edtBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onBeginEdit)];
            [edtBtn setImage:[UIImage imageNamed:XIUGAIZILIAOIMAGE]];
            
            
            UIBarButtonItem* resetPwdBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onBeginReSetPwd)];
            [resetPwdBtn setImage:[UIImage imageNamed:XIUGAIMIMAIMAGE]];
            
            
            
            [items addObjectsFromArray:[NSArray arrayWithObjects:flexSpace,resetPwdBtn,flexSpace,edtBtn,flexSpace, nil]];
        }
        
    }
    else
    {
        UIBarButtonItem* imBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onImMessage)];
        [imBtn setImage:[UIImage imageNamed:WEIKAITONGIMAGE]];
        
        
        UIBarButtonItem* callBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onCall)];
        [callBtn setImage:[UIImage imageNamed:DADIANHUAIMAGE]];
        
        UIBarButtonItem* shortMsgBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onShortMessage)];
        [shortMsgBtn setImage:[UIImage imageNamed:FADUANXINIMAGE]];
        
        
        [items addObjectsFromArray:[NSArray arrayWithObjects:imBtn,flexSpace,callBtn,flexSpace,shortMsgBtn, nil]];
        
    }
    
    [self.actionBar setItems:items];
}

-(void)onCommitEdit
{
    self.editState = !self.editState;
    [self setActionBarItems];
    [self.tableview reloadData];
    
    
    NSString*phoneNumMobile = self.cellPhoneNum.value.text;
    NSString*sign = self.cellSign.value.text;
    NSString*content = self.cellContent.value.text;
    

    NSDictionary *parameters = @{@"job_no":self.psn.job_no,
                                 @"acc_password": self.psn.password,
                                 @"DeviceID" : [UtilFun getUDID],
                                 @"acc_name" : @"",
                                 @"obj_mobile" : phoneNumMobile,
                                 @"acc_remarks" : sign,
                                 @"acc_content" : content
                                 };
    
    SHOWHUD_WINDOW
    [NetWorkManager PostWithApiName:EDIT_STAFF_INFO parameters:parameters success:
     ^(id responseObject)
     {
         [person me].obj_mobile = phoneNumMobile;
         [person me].acc_remarks = sign;
         [person me].acc_content = content;
         
         [self.tableview reloadData];
         
         HIDEHUD_WINDOW
         
         PRESENTALERT(@"修改成功",nil, nil, nil);
         
     }
                            failure:^(NSError *error)
     {
         HIDEHUD_WINDOW
         
         PRESENTALERT(@"修改失败", error.localizedDescription, nil, nil);
     }];
    
}

-(void)onBeginEdit
{
    self.editState = !self.editState;
    [self setActionBarItems];

    [self.tableview reloadData];
}


-(void)onBeginReSetPwd
{
    UIStoryboard* curStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    RestPassWordViewController*vc =[curStory instantiateViewControllerWithIdentifier:@"RestPassWordViewController"];
    if ([vc  isKindOfClass:[RestPassWordViewController class]])
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)onImMessage
{
    
}

-(void)onCall
{
    
}

-(void)onShortMessage
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
