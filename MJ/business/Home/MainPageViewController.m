//
//  MainPageViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MainPageViewController.h"
#import "UIViewController+FastNavgationBarItem.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "UtilFun.h"
#import "person.h"

#import "badgeImageFactory.h"
#import "unReadManager.h"
#import "annoucementManager.h"
#import "petitionManager.h"


#import "MainPageTableViewHeaderCell.h"
#import "PublicAnncTableViewCell.h"
#import "PetitionTableViewCell.h"
#import "announcement.h"
#import "petiotionBrief.h"

#import "AnncDetailsViewController.h"
#import "AnncListViewController.h"


#import "petionDetailsTableViewController.h"

#import "MessagePageViewController.h"


@interface MainPageViewController ()

@end


@implementation MainPageViewController


#pragma mark initView
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self setNavBarTitleTextAttribute];
    [self initBadgeNavBarWithUnReadAlertCount:0 andMsgCount:0];
    [self initTable];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}
-(void)setNavBarTitleTextAttribute
{
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ButtonBig"] forBarMetrics:UIBarMetricsDefault];
//    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                            NSFontAttributeName: [UIFont systemFontOfSize:[UIFont systemFontSize]],
//                            };
//    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
    
}

-(void)initBadgeNavBarWithUnReadAlertCount:(int)alertCnt andMsgCount:(int)msgCnt
{
    //self.navigationItem.rightBarButtonItem.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
#endif
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSString*unReadAlertStr =(alertCnt<=0)?@"":[NSString stringWithFormat:@"%d",alertCnt];
    NSString*unReadMsgStr =(msgCnt<=0)?@"":[NSString stringWithFormat:@"%d",msgCnt];

    
    UIImage*alertImage = [badgeImageFactory getBadgeImageFromImage:[UIImage imageNamed:@"ButtonUnreadAlert"] andText:unReadAlertStr];
    UIImage*msgImage = [badgeImageFactory getBadgeImageFromImage:[UIImage imageNamed:@"ButtonUnreadMessage"] andText:unReadMsgStr];
    
    [self setupLeftMenuButtonOfVC:self Image:msgImage action:@selector(leftMsgBtnSelected:)];
    [self setupRightMenuButtonOfVC:self Image:alertImage action:@selector(rightAlertBtnSelected:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"提醒" style:UIBarButtonItemStylePlain target:self action:@selector(leftMsgBtnSelected:)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initWithTitle:@"站内信" style:UIBarButtonItemStylePlain target:self action:@selector(rightAlertBtnSelected:)];
}


-(void)initTable
{
    
    //self.tableView = [[UITableView alloc ] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self.view addSubview:self.tableView];
}


#pragma mark -


#pragma mark Retrieve data from server
#pragma mark -

-(void)initData
{
    self.mainAnncArr = nil;
    self.mainPetitionArr = nil;
}
-(void)getUnReadAlertCnt
{
    SHOWHUD(self.view);
   [unReadManager getUnReadAlertCntSuccess:^(id responseObject) {
       HIDEHUD(self.view);
       
       [self initBadgeNavBarWithUnReadAlertCount:[unReadManager unReadAlertCnt] andMsgCount:[unReadManager unReadMessageCount]];
       
   } failure:^(NSError *error) {
       HIDEHUD(self.view);
   }];
}


-(void)getUnReadMsgCnt
{
    SHOWHUD(self.view);
    [unReadManager getUnReadMessageCntSuccess:^(id responseObject) {
        HIDEHUD(self.view);
        [self initBadgeNavBarWithUnReadAlertCount:[unReadManager unReadAlertCnt] andMsgCount:[unReadManager unReadMessageCount]];
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
}

-(void)getPetitionData
{
    SHOWHUD(self.view);
    [petitionManager getListFrom:@"0" To:@"" Count:4 Success:^(id responseObject) {
        HIDEHUD(self.view);
        if (responseObject != nil)
        {
            self.mainPetitionArr = responseObject;

        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
    
}

-(void)getAnncData
{
    SHOWHUD(self.view);
    [annoucementManager getListFrom:@"0" To:@"" Count:4 Success:^(id responseObject) {
        HIDEHUD(self.view);
        self.mainAnncArr = responseObject;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];

}



-(void)loadData
{
    [self getUnReadAlertCnt];
    [self getUnReadMsgCnt];
    [self getPetitionData];
    [self getAnncData];
}

#pragma mark
#pragma mark
#pragma mark  -


#pragma mark tableview about
#pragma mark  -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (indexPath.section == 0)
    {
        if (self.mainAnncArr && [self.mainAnncArr count] > indexPath.row)
        {
             [self performSegueWithIdentifier:@"viewAnncDetails" sender:self];
        }
        
        
    }
    else if(indexPath.section == 1)
    {
        if (self.mainPetitionArr && [self.mainPetitionArr count] > indexPath.row)
        {
            [self performSegueWithIdentifier:@"toPetionDetails" sender:self];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"MainPageTableViewHeaderCell";
    
    MainPageTableViewHeaderCell *cell=(MainPageTableViewHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[MainPageTableViewHeaderCell class]])
            {
                cell = (MainPageTableViewHeaderCell *)oneObject;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (section == 0)
    {
        [cell initWithTitle:@"公告" andAction:^(UIButton *btn)
         {
             [self toAnncListView:btn];
         }];
    }
    else
    {
        [cell initWithTitle:@"签程" andAction:^(UIButton *btn)
         {
             [self toPetitionListView:btn];
         }];
    }
    
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0)
//    {
//        return 4;
//    }
//    else if(section == 1)
//    {
//        return self.mainPetitionArr.count;
//    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger iRow = indexPath.row;
    
    UITableViewCell*cell = nil;
    
    
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"PublicAnncTableViewCell";
        
        PublicAnncTableViewCell *cell=(PublicAnncTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[PublicAnncTableViewCell class]])
                {
                    cell = (PublicAnncTableViewCell *)oneObject;
                }
            }
        }
        if (self.mainAnncArr && iRow < self.mainAnncArr.count)
        {
            announcement*annc = [self.mainAnncArr objectAtIndex:iRow];
            NSString*title =nil;
            BOOL isNew = FALSE;
            if (annc)
            {
                title = annc.notice_title;
                isNew = annc.isNew;
            }
            
            [cell initWithTitle:title isNew:isNew];

        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSString *CellIdentifier = @"PetitionTableViewCell";
        
        PetitionTableViewCell *cell=(PetitionTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            for(id oneObject in nibs)
            {
                if([oneObject isKindOfClass:[PetitionTableViewCell class]])
                {
                    cell = (PetitionTableViewCell *)oneObject;
                }
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (self.mainPetitionArr && iRow < self.mainPetitionArr.count)
        {
            petiotionBrief*ptionBr = [self.mainPetitionArr objectAtIndex:iRow];
            if (ptionBr)
            {
               [cell initWithType:ptionBr.flowtype reason:ptionBr.reason person:ptionBr.username];

            }

        }
        return cell;
    }
    
   
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}


#pragma mark
#pragma mark
#pragma mark  -


#pragma mark navigationbar about
#pragma mark  -
-(void)leftMsgBtnSelected:(id)sender
{
    MessagePageViewController*msgPage = [[MessagePageViewController alloc] init];
    [self.navigationController pushViewController:msgPage animated:YES];
}

-(void)rightAlertBtnSelected:(id)sender
{
    [self performSegueWithIdentifier:@"toAlertList" sender:self];
}

-(void)toAnncListView:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"toAnncList" sender:self];
}

-(void)toPetitionListView:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"toPetitionList" sender:self];
    
}
#pragma mark -



#pragma mark other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"viewAnncDetails"])
    {
        if ([controller isKindOfClass:[AnncDetailsViewController class]])
        {
            AnncDetailsViewController *detailController = (AnncDetailsViewController *)controller;
            NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
            
            detailController.annc = [self.mainAnncArr objectAtIndex:selectIndexPath.row];
            

        }
        else
        {
           
        }
       
    }
    else if([segue.identifier isEqual:@"toAnncList"])
    {
        if ([controller isKindOfClass:[AnncListViewController class]])
        {
//            anncListViewController *Controller = (anncListViewController *)controller;
//            NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];

            
            
        }
        else
        {
            
        }
    }
    else if([segue.identifier isEqual:@"showContact"])
    {
        if ([controller isKindOfClass:[ContactListTableViewController class]])
        {
            ContactListTableViewController*contactLst = (ContactListTableViewController*)controller;
            contactLst.selectMode = YES;
            contactLst.selectResultDelegate = self;

        }
        else
        {
            
        }
    }
    else if([segue.identifier isEqual:@"toPetionDetails"])
    {
        if ([controller isKindOfClass:[petionDetailsTableViewController class]])
        {
            petionDetailsTableViewController*contactLst = (petionDetailsTableViewController*)controller;
            NSIndexPath *selectIndexPath = [self.tableView indexPathForSelectedRow];
            contactLst.petitionID = ((petiotionBrief*)[self.mainPetitionArr objectAtIndex:selectIndexPath.row]).id;
            contactLst.petitionTaskID = ((petiotionBrief*)[self.mainPetitionArr objectAtIndex:selectIndexPath.row]).taskid;
        }
        else
        {
            
        }
    }
    
    
}


#pragma mark -
-(void)returnSelection:(NSArray *)curSelection
{
    
}

@end
