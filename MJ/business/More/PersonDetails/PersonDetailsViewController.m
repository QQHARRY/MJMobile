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

@interface PersonDetailsViewController ()

@end

@implementation PersonDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoChanged = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"修改密码" style:UIBarButtonItemStylePlain target:self action:@selector(editPassWordBtnClicked:)];
    
    NSString*tmp = @"所属公司:";
    self.company.text = [tmp stringByAppendingString:[person me].company_name];
    
    tmp = @"所属部门:";
    self.department.text = [tmp stringByAppendingString:[person me].department_name];
    
    tmp = @"姓名:";
    self.myName.text = [tmp stringByAppendingString:[person me].name_full];
    
    tmp = @"登录角色:";
    self.character.text = [tmp stringByAppendingString:[person me].role_name];
    
    tmp = @"最后登录IP:";
    self.lastLoginIP.text = tmp;
    tmp = @"时间:";
    self.lastLoginTime.text = tmp;
    
    
    self.loginName.text = [person me].job_name;
    self.mobileNum.text = [person me].obj_mobile;
    self.chracterSign.text = [person me].acc_remarks;
    self.personalInfo.text = [person me].acc_content;
    self.loginName.enabled = YES;
    self.mobileNum.enabled = YES;
    self.chracterSign.enabled = YES;
    self.personalInfo.enabled = YES;
    self.myPhoto.enabled = YES;
    
    // Do any additional setup after loading the view.
    
    [self initConstrains];
}

-(void)editPassWordBtnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"showRestPassword" sender:self];
}

-(void)initConstrains
{
    self.company.translatesAutoresizingMaskIntoConstraints = NO;
//    self.department.translatesAutoresizingMaskIntoConstraints = NO;
//    self.character.translatesAutoresizingMaskIntoConstraints = NO;
//    self.lastLoginIP.translatesAutoresizingMaskIntoConstraints = NO;
//    self.lastLoginTime.translatesAutoresizingMaskIntoConstraints = NO;

    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.company attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0]];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myPhoto attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:0 constant:15]];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
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
    NSString*userID = [person me].job_no;

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
    NSString*userID = [person me].job_no;

    NSData *imageData = UIImagePNGRepresentation(currentImage);
    
    NSString *fullPath = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:userID] stringByAppendingString:@"_"]stringByAppendingString:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
    
    self.photoChanged = YES;
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
        [UtilFun presentPopViewControllerWithTitle:@"信息填写不全" Message:@"请填写完成" SimpleAction:@"OK" Sender:self];
        return;
    }
    
    SHOWHUD(self.view);
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password": [person me].password,
                                 @"DeviceID" : [UtilFun getUDID],
                                 @"acc_name" : accName,
                                 @"obj_mobile" : phoneNumMobile,
                                 @"acc_remarks" : chSign,
                                 @"acc_content" : chInfo
                                 };
    [NetWorkManager PostWithApiName:EDIT_STAFF_INFO parameters:parameters success:
     ^(id responseObject)
     {
         HIDEHUD(self.view);
         
     }
                            failure:^(NSError *error)
     {
         HIDEHUD(self.view);
         
         
     }];
    
    if (self.photoChanged)
    {
        
    }
    
}
@end
