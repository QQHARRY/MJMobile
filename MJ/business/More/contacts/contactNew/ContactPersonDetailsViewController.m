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
#import "photoManager.h"
#import "UIImageView+AFNetworking.h"
#import "postFileUtils.h"
#import "UtilFun.h"
#import "UIImageView+RoundImage.h"
#import "EaseMob.h"
#import "UIImage+FX.h"
#import "ChatViewController.h"
#import "UIViewController+ContactsFunction.h"
#import "UIImageView+LoadPortraitOfPerson.h"
#import "CLImageEditor.h"
#import "CLClippingTool.h"
#import "CLClippingTool+CustomizeItems.h"
#import "CLFilterTool.h"



@interface ContactPersonDetailsViewController ()<CLImageEditorDelegate,CLClippingToolItemsDataSource>


@property(strong,nonatomic)ContactPersonDetailsVCTableViewCell*cellPhoneNum;
@property(strong,nonatomic)ContactPersonDetailsVCTableViewCell*cellSign;
@property(strong,nonatomic)ContactPersonDetailsVCTableViewCell*cellContent;
@end

@implementation ContactPersonDetailsViewController
@synthesize psn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    //self.navigationController.tabBarController.tabBar.hidden = YES;
    //self.hidesBottomBarWhenPushed = YES;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableview setContentSize:self.view.frame.size];

    
    self.editState = NO;
    self.nameAndNo.text = [NSString stringWithFormat:@"%@ %@",self.psn.name_full,self.psn.job_no];


    [self setActionBarItems];
    [self setUpPhotoAbout];
}





-(void)setUpPhotoAbout
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapScreen:)];
    self.photoImage.userInteractionEnabled = YES;
    [self.photoImage addGestureRecognizer:recognizer];
    if ([photoManager getPhotoByPerson:psn])
    {
        self.photoImage.image = [photoManager getPhotoByPerson:psn];
    }
    else
    {
        [self.photoImage loadPortraitOfPerson:psn withDefault:[UIImage imageNamed:@"个人详情默认头像"] round:NO];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewDidLayoutSubviews
{
    CGRect rct = self.photoImage.frame;
    if (rct.size.width == rct.size.height)
    {
        [self.photoImage.layer setCornerRadius:self.photoImage.frame.size.height/2];
        [self.photoImage.layer setMasksToBounds:YES];
    }
    
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

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = [UIColor whiteColor];
//}

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
                
                NSString* dept = self.psn.department_name;
                if (dept==nil || dept.length == 0)
                {
                    dept = self.psn.dept_name;
                }
                
                if (dept != nil)
                {
                    cell.value.text = dept;
                }
                
                [cell setEditAble:NO];
            }
                break;
            case 2:
            {
                cell.typeImage.image = [UIImage imageNamed:ZHIWEIIMAGE];
                cell.type.text = ZHIWEI;
                cell.value.text = self.psn.technical_post_name;
                if (cell.value.text==nil || cell.value.text.length == 0)
                {
                    cell.value.text = self.psn.job_name;
                }
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


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    //self.navigationController.tabBarController.tabBar.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    

    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    //self.navigationController.tabBarController.tabBar.hidden = NO;

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
    
    if ([self.psn isEqual:[person me]] || [self.psn.job_no isEqualToString:[person me].job_no])
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
        UIBarButtonItem*imBtn = nil;
        
        IMSTATE imState = [self.psn imState];
        [[person me] isImOpened];
        
        switch (imState)
        {
            case IM_NOT_OPEN:
            {
                UIBarButtonItem* imNotOpenBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
                [imNotOpenBtn setImage:[UIImage imageNamed:WEIKAITONGIMAGE]];
                imNotOpenBtn.enabled = NO;
                imBtn = imNotOpenBtn;
            }
                break;
            case IM_OPENED_NOT_FRIEND:
            {
                UIBarButtonItem* imNotFriendBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onAddFriend)];
                [imNotFriendBtn setImage:[UIImage imageNamed:JIAHAOYOUIMAGE]];
                imBtn = imNotFriendBtn;
            }
                break;
            case IM_FRIEND:
            {
                UIBarButtonItem* imFriend = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onImMessage)];
                [imFriend setImage:[UIImage imageNamed:FAXIAOXIIMAGE]];
                imBtn = imFriend;
            }
                break;
            default:
            {
                UIBarButtonItem* imNotOpenBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onImMessage)];
                [imNotOpenBtn setImage:[UIImage imageNamed:WEIKAITONGIMAGE]];
                imNotOpenBtn.enabled = NO;
                imBtn = imNotOpenBtn;
            }
                break;
        }


        
        
        
        UIBarButtonItem* callBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onCall)];
        [callBtn setImage:[UIImage imageNamed:DADIANHUAIMAGE]];
        BOOL bEnable = (self.psn.obj_mobile!= nil)&&((self.psn.obj_mobile.length) > 0);

        
        UIBarButtonItem* shortMsgBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(onShortMessage)];
        [shortMsgBtn setImage:[UIImage imageNamed:FADUANXINIMAGE]];
        shortMsgBtn.enabled = bEnable;
        

        callBtn.enabled = [UtilFun isIphoneAboutHardWare] && bEnable;
        shortMsgBtn.enabled = [UtilFun isIphoneAboutHardWare] && bEnable;
        
        
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
         
         PRESENTALERT(@"修改成功",nil, nil,nil, nil);
         
     }
                            failure:^(NSError *error)
     {
         HIDEHUD_WINDOW
         
         PRESENTALERT(@"修改失败", error.localizedDescription, nil, nil,nil);
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
    [self ct_onImMessage:self.psn];
}

-(void)onAddFriend
{
    [self ct_onAddFriend:self.psn];
    
}

-(void)onCall
{
    [self ct_onCall:self.psn];
}

-(void)onShortMessage
{
    [self ct_onShortMessage:self.psn];
}



- (void)onTapScreen:(UITapGestureRecognizer *)tap
{
    if (self.psn == [person me] || [self.psn.job_no isEqualToString:[person me].job_no])
    {
        UIActionSheet *sheet;
        
        
        NSString* take = @"照相";
        NSString* choose = @"从相册选择";
        NSString* cancel = @"取消";
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            sheet  = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:cancel otherButtonTitles:take,choose, nil];
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:cancel otherButtonTitles:choose, nil];
            
        }
        
        sheet.tag = 1;
        
        [sheet showInView:self.view];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        
        NSUInteger sourceType = 0;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            switch (buttonIndex)
            {
                case 0:
                    return;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                return;
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = NO;
        
        imagePickerController.sourceType = sourceType;
        imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}


#pragma mark - image picker delegte

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (image == nil)
    {
        return;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [CLClippingTool setupWithDataSource:self];
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image SingleEditting:YES SingleEdittingClass:[CLClippingTool class]];
    editor.delegate = self;
    //[picker presentViewController:editor animated:YES completion:nil];
    [self.navigationController pushViewController:editor animated:YES];
}


-(CliplingRatio*)CLClippingRatio;
{
    return [CliplingRatio RatioWithWidthSide:3 andHeightSide:4];
}

-(void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    NSData*data = UIImageJPEGRepresentation(image, 0.25);
    
    
    NSMutableDictionary*params = [[NSMutableDictionary alloc] init];
    [params setValue:[person me].job_no forKey:@"job_no"];
    [params setValue:[person me].password forKey:@"acc_password"];
    [params setValue:[UtilFun getUDID] forKey:@"DeviceID"];
    
    
    NSString*strUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, EDIT_PERSON_PHOTO];
    
    SHOWHUD_WINDOW;
    [postFileUtils postFileWithURL:[NSURL URLWithString:strUrl] data:data Parameter:params ServerParamName:@"photo" FileName:@"myPhoto" MimeType:@"image/jpeg" Success:^(id responseObj){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [photoManager setPhoto:image ForPerson:[person me]];
            
            self.photoImage.image = image;
            //[self.photoImage setImageToRound:image];
            HIDEHUD_WINDOW;
            PRESENTALERT(@"修改成功", nil, nil,nil, nil);
        });
        
        
    } failure:^(NSError *error) {
        NSString*errMsg = SERVER_NONCOMPLIANCE_INFO;
        if (error)
        {
            errMsg = error.description;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            HIDEHUD_WINDOW;
            PRESENTALERT(@"修改失败", errMsg, nil,nil, nil);
        });
        
        
        
    }];
}

-(void)imageEditorDidCancel:(CLImageEditor *)editor
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
