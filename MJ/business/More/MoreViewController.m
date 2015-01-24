//
//  MoreViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MoreViewController.h"
#import "badgeImageFactory.h"
#import "JSBadgeView.h"
#import "myBriefTableViewCell.h"
#import "person.h"
#import "AppDelegate.h"
#import "PersonDetailsViewController.h"
#import "Macro.h"
#import "UIImageView+AFNetworking.h"

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
    if(indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"showPersonDetails" sender:self];
    }
    else if(indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"showContactList" sender:self];
    }
    else if(indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"showShopRootView" sender:self];
    }
    else if(indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"showAboutView" sender:self];
    }
    else if(indexPath.row == 5)
    {
        [self performSegueWithIdentifier:@"showSuggestionView" sender:self];
    }
    else if(indexPath.row == 6)
    {

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确定退出登录" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self toLoginPage];
    }
}

-(void)toLoginPage
{
    AppDelegate*app = [[UIApplication sharedApplication] delegate];
    [app loadMainSotry:NO];
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
    return 7;
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
        
        NSString*photoUrl = [person me].photo;
        if ([photoUrl length] == 0)
        {
            cell.myPhoto.image = [UIImage imageNamed:@"defaultPhoto"];
        }
        else
        {
            NSString*strUrl = [SERVER_ADD stringByAppendingString:photoUrl];
            
            [cell.myPhoto setImageWithURL:[NSURL URLWithString:strUrl]];
        }
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
        else if(indexPath.row == 3)
        {
            cell.textLabel.text = @"关于";
        }
        else if(indexPath.row == 4)
        {
            cell.textLabel.text = @"检查更新";
        }
        else if(indexPath.row == 5)
        {
            cell.textLabel.text = @"意见反馈";
        }
        else if (indexPath.row == 6)
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
            PersonDetailsViewController *detailController = (PersonDetailsViewController *)controller;
            
            
            detailController.psn = [person me];
            
            
        }
        else
        {
            
        }
        
    }

    
    
}


@end
