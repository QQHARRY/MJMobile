//
//  PersonDetailsViewController.m
//  MJ
//
//  Created by harry on 14/12/20.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "person.h"
#import "UtilFun.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

@interface PersonDetailsViewController ()

@end

@implementation PersonDetailsViewController
@synthesize psn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoChanged = NO;
    if (psn == nil)
    {
        return;
    }
    
    if (psn == [person me])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"修改密码" style:UIBarButtonItemStylePlain target:self action:@selector(editPassWordBtnClicked:)];
        self.loginName.enabled = YES;
        self.mobileNum.enabled = YES;
        self.chracterSign.enabled = YES;
        self.personalInfo.enabled = YES;
        self.myPhoto.enabled = YES;
        self.phoneBtn.hidden = YES;
        self.smsBtn.hidden = YES;
        self.saveBtn.hidden = NO;
    }
    else
    {
        self.loginName.enabled = NO;
        self.mobileNum.enabled = NO;
        self.chracterSign.enabled = NO;
        self.personalInfo.enabled = NO;
        self.myPhoto.enabled = NO;
        self.phoneBtn.hidden = NO;
        self.smsBtn.hidden = NO;
        self.saveBtn.hidden = YES;
        self.smsBtn.enabled = NO;
        self.phoneBtn.enabled = NO;
    }
    
    self.loginName.text = psn.job_name;
    
    if (psn.obj_mobile && psn.obj_mobile.length > 0)
    {
        self.mobileNum.text = psn.obj_mobile;
        
        if ([UtilFun isIphoneAboutHardWare])
        {
            self.smsBtn.enabled = YES;
            self.phoneBtn.enabled = YES;
        }
        
    }

    
    self.chracterSign.text = psn.acc_remarks;
    self.personalInfo.text = psn.acc_content;
    NSString*tmp = @"所属公司:";
    self.company.text = [tmp stringByAppendingString:psn.company_name];
    
    tmp = @"所属部门:";
    self.department.text = [tmp stringByAppendingString:psn.department_name];
    
    tmp = @"姓名:";
    self.myName.text = [tmp stringByAppendingString:psn.name_full];
    
    tmp = @"登录角色:";
    self.character.text = [tmp stringByAppendingString:psn.role_name];
    
    tmp = @"最后登录IP:";
    self.lastLoginIP.text = tmp;
    tmp = @"时间:";
    self.lastLoginTime.text = tmp;
    
    
    
    NSString*photoUrl = psn.photo;
    if ([photoUrl length] == 0)
    {
        [self.myPhoto setBackgroundImage:[UIImage imageNamed:@"defaultPhoto"] forState:UIControlStateNormal];
    }
    else
    {
        NSString*strUrl = [SERVER_ADD stringByAppendingString:photoUrl];

        [self.myPhoto setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:strUrl]];
    }
    
    // Do any additional setup after loading the view.
    
    [self initConstrains];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.loginName resignFirstResponder];
    [self.mobileNum resignFirstResponder];
    [self.chracterSign resignFirstResponder];
    [self.personalInfo resignFirstResponder];
}

-(void)editPassWordBtnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"showRestPassword" sender:self];
}

-(void)initConstrains
{
    self.company.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.company attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

- (void)setPhoto
{
    NSString*userID = psn.job_no;

    NSString *fullPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:userID] stringByAppendingString:@"_"]stringByAppendingString:@"myPhotoName"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    if (savedImage == nil)
    {
        savedImage = [UIImage imageNamed:@"defaultPhoto"];
    }
    
    [self.myPhoto setBackgroundImage:savedImage forState:UIControlStateNormal];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self saveImage:image withName:@"myPhotoName"];
    [self setPhoto];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - save image to bundle
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSString*userID = psn.job_no;

    NSData *imageData = UIImagePNGRepresentation(currentImage);
    
    NSString *fullPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:userID] stringByAppendingString:@"_"]stringByAppendingString:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
    
    self.photoChanged = YES;
}

- (IBAction)phoneBtnClicked:(id)sender {

    UIWebView*callWebview =[[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",psn.obj_mobile]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    
}

- (IBAction)smsBtnClicked:(id)sender {

    UIWebView*callWebview =[[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",psn.obj_mobile]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

- (IBAction)clickPhotoBtn:(id)sender {
    
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

- (IBAction)clickSaveButton:(id)sender {
    [self commiteInfo];
}


-(void)commiteInfo
{
    NSString*accName = self.loginName.text;
    NSString*phoneNumMobile = self.mobileNum.text;
    NSString*chSign = self.chracterSign.text;
    NSString*chInfo = self.personalInfo.text;
    
    if (accName.length ==0 || phoneNumMobile.length == 0 || chSign.length == 0 || chInfo.length == 0)
    {
        PRESENTALERT(@"信息填写不全",@"请填写完成",@"OK",self);
        return;
    }
    
    SHOWHUD(self.view);
    NSDictionary *parameters = @{@"job_no":psn.job_no,
                                 @"acc_password": psn.password,
                                 @"DeviceID" : [UtilFun getUDID],
                                 @"acc_name" : accName,
                                 @"obj_mobile" : phoneNumMobile,
                                 @"acc_remarks" : chSign,
                                 @"acc_content" : chInfo
                                 };
    [NetWorkManager PostWithApiName:EDIT_STAFF_INFO parameters:parameters success:
     ^(id responseObject)
     {
         [person me].job_name = accName;
         [person me].obj_mobile = phoneNumMobile;
         [person me].acc_remarks = chSign;
         [person me].acc_content = chInfo;
         HIDEHUD(self.view);
         
     }
                            failure:^(NSError *error)
     {
         HIDEHUD(self.view);
         
         
     }];
    
    if (self.photoChanged)
    {
        self.photoChanged = NO;
        SHOWHUD(self.view);
        UIImage*image = [self.myPhoto backgroundImageForState:UIControlStateNormal];
        NSData*data = UIImageJPEGRepresentation(image, 0.5);
        
        NSDictionary *parameters = @{@"job_no":psn.job_no,
                                     @"acc_password": psn.password,
                                     @"DeviceID" : [UtilFun getUDID],
                                     };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"%@%@", SERVER_URL, EDIT_PERSON_PHOTO] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
        {
            [formData appendPartWithFormData:data name:@"photo"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            HIDEHUD(self.view);
            NSLog(@"success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HIDEHUD(self.view);
            NSLog(@"failed");
        }];
 
    }
    
}
@end
