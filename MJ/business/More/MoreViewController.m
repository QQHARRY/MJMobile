//
//  MoreViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MoreViewController.h"


#import "myBriefTableViewCell.h"
#import "person.h"
#import "AppDelegate.h"
#import "PersonDetailsViewController.h"
#import "Macro.h"
#import "UIImageView+AFNetworking.h"
#import "photoManager.h"
#import "UtilFun.h"
#import "SignTableViewController.h"
#import "ContactDeptViewController.h"
#import "ContactPersonDetailsViewController.h"
#import "SettingsViewController.h"
#import "PushNotificationViewController.h"
#import "UIViewController+logoutAndDownloadNewVersion.h"
#import "UIImageView+LoadPortraitOfPerson.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initTableView];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //[self setNavBarTitleTextAttribute];
    self.title = @"更多";
}


-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
-(void)initTableView
{
//    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-128);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavBarTitleTextAttribute
{
        NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:[UIFont systemFontSize]],
                                };
        [self.navigationController.navigationBar setTitleTextAttributes:attrs];
    
}

#pragma mark tableview about
#pragma mark  -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row == 0)
    {
        //[self performSegueWithIdentifier:@"showPersonDetails" sender:self];
        UIStoryboard* curStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        ContactPersonDetailsViewController*vc =[curStory instantiateViewControllerWithIdentifier:@"ContactPersonDetailsViewController"];
        if ([vc  isKindOfClass:[ContactPersonDetailsViewController class]])
        {
            vc.psn = [person me];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.row == 1)
    {
        //[self performSegueWithIdentifier:@"showContactList" sender:self];
        [self performSegueWithIdentifier:@"showContactNew" sender:self]; 
    }
    else if(indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"showShopRootView" sender:self];
    }
//    else if(indexPath.row == 3)
//    {
//        SignTableViewController *c = [[SignTableViewController alloc] initWithNibName:@"SignTableViewController" bundle:nil];
//        [self.navigationController pushViewController:c animated:YES];
//    }
    else if (indexPath.row == 3)
    {
        PushNotificationViewController *pushController = [[PushNotificationViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:pushController animated:YES];

    }
    else if(indexPath.row == 4)
    {
        [self performSegueWithIdentifier:@"showAboutView" sender:self];
    }
    else if(indexPath.row == 5)
    {
       [self showHudInView:self.view hint:@"正在检测版本更新"];
        [[[CheckNewVersion alloc] init]  checkNewVersion:self];
    }
    else if(indexPath.row == 6)
    {
        [self performSegueWithIdentifier:@"showSuggestionView" sender:self];
        
    }
    else if(indexPath.row == 7)
    {

        PRESENTALERTWITHHANDER_WITHDEFAULTCANCEL(@"确定退出登录?", @"", @"确定", ^(){
            [self toLoginPage];
        }, @"取消", nil, self);
    }
    
}

-(void)hasNewVersion:(BOOL)bHasNewVersion VersionName:(NSString *)vName ReleaseNote:(NSString *)releaseNote VersionSize:(NSString *)size VersionAddress:(NSString *)address RequiredToUpdate:(BOOL)updateRequired
{
    [self hideHud];
    if (bHasNewVersion)
    {
        if (updateRequired)
        {
            [self quitAndDLNewVersion:vName ReleaseNote: releaseNote Address:address];
        }
       
        
    }
    else
    {
        PRESENTALERT(@"当前版本已是最新版", nil, nil,nil, nil);
    }
}



-(void)toLoginPage
{
    AppDelegate*app = [[UIApplication sharedApplication] delegate];

    [app appLogout];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 88;
    }
    
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0)
    {
        NSString *CellIdentifier = @"myBriefTableViewCell";
        
        myBriefTableViewCell *cell=(myBriefTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[myBriefTableViewCell class]])
                {
                    cell = (myBriefTableViewCell *)oneObject;
                }
            }
        }
        if ([photoManager getPhotoByPerson:[person me]])
        {
            cell.myPhoto.image = [photoManager getPhotoByPerson:[person me]];
        }
        else
        {
            NSString*photoUrl = [person me].photo;
            if ([photoUrl length] == 0)
            {
                cell.myPhoto.image = [UIImage imageNamed:@"个人详情默认头像"];
            }
            else
            {
                [cell.myPhoto loadPortraitOfPerson:[person me] withDefault:[UIImage imageNamed:@"个人详情默认头像"] round:NO];
            }
        }
        
        
        
        
        cell.myName.text = [person me].name_full;
        cell.myXX.text = [person me].acc_remarks;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        NSString*key = @"cell";
        
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:key];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc ] init];
        }
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"企业通讯录";
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"后勤管理";
        }
//        else if(indexPath.row == 3)
//        {
//            cell.textLabel.text = @"预约签约";
//        }
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"消息推送设置";
        }
        else if(indexPath.row == 4)
        {
            cell.textLabel.text = @"关于";
        }
        else if(indexPath.row == 5)
        {
            cell.textLabel.text = @"检查更新";
        }
        else if(indexPath.row == 6)
        {
            cell.textLabel.text = @"意见反馈";
        }
        else if (indexPath.row == 7)
        {
            cell.textLabel.text = @"退出登录";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    
    
    return nil;
}




#pragma mark
#pragma mark


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"showPersonDetails"])
    {
        if ([controller isKindOfClass:[PersonDetailsViewController class]])
        {
//            PersonDetailsViewController *detailController = (PersonDetailsViewController *)controller;
//            
//            
//            detailController.psn = [person me];
            
          
        }
        else
        {
            
        }
        
    }
    else if([segue.identifier isEqual:@"showContactNew"])
    {
        if ([controller isKindOfClass:[ContactDeptViewController class]])
        {
            ContactDeptViewController *vc = (ContactDeptViewController *)controller;
            
            
            vc.superUnit = [department rootUnit];
            vc.isSearchMode = NO;
            
        }
        else
        {
            
        }
    }

    
    
}


@end
