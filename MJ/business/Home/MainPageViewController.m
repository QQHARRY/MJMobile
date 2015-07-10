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
#import "CheckNewVersion.h"


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
#import "MJRefresh.h"

#import "petionDetailsTableViewController.h"

#import "MessagePageViewController.h"

#import "dictionaryManager.h"

#import "ChatListViewController.h"
#import "AppDelegate.h"
#import "UIBarButtonItem+Badge.h"
#import "UIViewController+logoutAndDownloadNewVersion.h"
#import "ImagePlayerView.h"
#import "UIImageView+AFNetworking.h"
#import "Macro.h"
#import "MainPageLabeView.h"
#import "MainPageButton.h"
#import "WCAlertView.h"
#import "HomeIndicator.h"
#import "UIButton+Badge.h"
#import "UIImageView+EMWebCache.h"
#import "BannerData.h"
#import "WebViewController.h"
#import "Sqlite3DataPersistence.h"
#import "testReTableViewBug.h"


#define TABBARTITLECOLOR [UIColor colorWithRed:1/255.0f green:0xaf/255.0f blue:0xe8/255.0f alpha:1]
#define ALERTBTN_COLOR [UIColor colorWithRed:0xf8/255.0f green:0x64/255.0f blue:0x58/255.0f alpha:1]
#define PETITIONBTN_COLOR [UIColor colorWithRed:0x0e/255.0f green:0xb6/255.0f blue:0xd0/255.0f alpha:1]
#define MSGBTN_COLOR [UIColor colorWithRed:0x45/255.0f green:0x8b/255.0f blue:0xff/255.0f alpha:1]

//#if 0
//UIWebView*webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height-66-44)];
//[self.view addSubview:webV];
//
//NSString*str = [NSString stringWithFormat:@"%@%@", SERVER_URL, API_PETITION_DETAIL];
//
//NSMutableDictionary*param = [[NSMutableDictionary alloc] init];
//[param setObject:[person me].job_no forKey:@"job_no"];
//[param setObject:[person me].password forKey:@"acc_password"];
//
//
//petiotionBrief*brief = [self.mainPetitionArr objectAtIndex:indexPath.row];
//[param setObject:brief.id forKey:@"id"];
//[param setObject:brief.taskid forKey:@"taskid"];
//
//
//
//NSString *array = @"";
//int i=0;
//for(NSString *key in param)
//{
//    if(i>0)
//    {
//        array = [array stringByAppendingString:@"&"];
//    }
//    
//    array = [array stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, [param objectForKey:key]]];
//    i++;
//}
//
//
//NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:str]];
//[request setHTTPMethod: @"POST"];
//
//[request setHTTPBody: [array dataUsingEncoding: NSUTF8StringEncoding]];
//
//[webV loadRequest:request];
//#endif

@interface MainPageViewController ()<ImagePlayerViewDelegate>
{
    int waitForAsynPulls;
}
@property(strong,nonatomic)NSArray*mainAnncArr;
@property(strong,nonatomic)NSArray*mainPetitionArr;

@property(strong,nonatomic)UIScrollView*scrollView;
@property(strong,nonatomic)ImagePlayerView*advertisementPlayer;
@property(strong,nonatomic)MainPageLabeView*todaysFollow;
@property(strong,nonatomic)MainPageLabeView*todaysAppointment;
@property(strong,nonatomic)MainPageLabeView*monthPerformance;
@property(strong,nonatomic)MainPageButton*alertBtn;
@property(strong,nonatomic)MainPageButton*petitionBtn;
@property(strong,nonatomic)MainPageButton*messageBtn;
@property(strong,nonatomic)UITableView*publicAnncTb;

@property(strong,nonatomic)HomeIndicator*indicator;
@property(assign,nonatomic)BOOL indicatorChanged;

@end


@implementation MainPageViewController


#pragma mark initView
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.navigationController.navigationBar.hidden = NO;
    [self.tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // 修改tabbar图标为原图颜色
    {
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
        item.selectedImage = [[UIImage imageNamed:@"TabItemHome"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [[UIImage imageNamed:@"TabItemHomeNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateNormal];
    }
    {
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
        item.selectedImage = [[UIImage imageNamed:@"TabItemHouse"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [[UIImage imageNamed:@"TabItemHouseNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateNormal];
    }
    {
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:2];
        item.selectedImage = [[UIImage imageNamed:@"TabItemCustom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [[UIImage imageNamed:@"TabItemCustomNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateNormal];
    }
    {
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:3];
        item.selectedImage = [[UIImage imageNamed:@"TabItemMessage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [[UIImage imageNamed:@"TabItemMessageNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateNormal];
    }
    
    {
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:4];
        item.selectedImage = [[UIImage imageNamed:@"TabItemMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [[UIImage imageNamed:@"TabItemMoreNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBARTITLECOLOR} forState:UIControlStateNormal];
    }
    [[[CheckNewVersion alloc] init] checkNewVersion:self];
    [self initUI];
    self.mainAnncArr = nil;
    
    [self updateDic];

    //注册通知
    _indicatorChanged = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indicatorCountChanged) name:MAINPAGE_INDICATOR_NUMBER_CHANGED object:nil];
    
    

}

-(void)indicatorCountChanged
{
    _indicatorChanged = YES;

}


-(void)reloadData
{
    waitForAsynPulls = 2;
    [self getAnncData];
    [self pullCountData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MAINPAGE_INDICATOR_NUMBER_CHANGED object:nil];

}

-(void)endRefreshing:(BOOL)isFoot
{
    if (isFoot)
    {
        [self.scrollView footerEndRefreshing];
    }
    else
    {
        [self.scrollView headerEndRefreshing];
    }
    
}


-(void)tryEndRefreshing:(BOOL)isFoot
{
    waitForAsynPulls--;
    if (waitForAsynPulls < 0)
    {
        waitForAsynPulls = 0;
    }
    else if(waitForAsynPulls == 0)
    {
        [self endRefreshing:isFoot];
    }
    
}

-(void)hasNewVersion:(BOOL)bHasNewVersion VersionName:(NSString*)vName ReleaseNote:(NSString *)releaseNote VersionSize:(NSString*)size VersionAddress:(NSString*)address RequiredToUpdate:(BOOL)updateRequired
{
    if (bHasNewVersion)
    {
        if (updateRequired)
        {
            [self quitAndDLNewVersion:vName ReleaseNote: releaseNote Address:address];
            
        }
       
        
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    if (_indicatorChanged)
    {
        _indicatorChanged = NO;
        [self reloadData];
    }
}
-(void)setNavBarTitleTextAttribute
{
    
}



#pragma mark -


#pragma mark Retrieve data from server
#pragma mark -
-(void)getAnncData
{
    //SHOWHUD(self.view);
    [annoucementManager getListFrom:@"0" To:@"" Count:6 Success:^(id responseObject) {
        //HIDEHUD(self.view);
        self.mainAnncArr = responseObject;
        [self.publicAnncTb reloadData];
        [self tryEndRefreshing:NO];
    } failure:^(NSError *error) {
        //HIDEHUD(self.view);
        [self tryEndRefreshing:NO];
    }];

}


-(void)pullCountData
{
    //SHOWHUD(self.view);
    [annoucementManager getHomeIndicatorCountDataSuccess:^(id responseObject) {
        //HIDEHUD(self.view);
        [self updateCountDataInfo:responseObject];
        [self tryEndRefreshing:NO];
    } failure:^(NSError *error) {
        //HIDEHUD(self.view);
        [self tryEndRefreshing:NO];
    }];
}

-(void)updateCountDataInfo:(HomeIndicator*)indicator
{
    if (indicator == nil)
    {
        return;
    }
    
    self.indicator = indicator;
   dispatch_async(dispatch_get_main_queue(), ^{
      
       
       [self.todaysFollow setContentText:[NSString stringWithFormat:@"%d",(int)indicator.follow_count]];
       [self.todaysAppointment setContentText:[NSString stringWithFormat:@"%d",(int)indicator.appoint_count]];
       
       
       NSString*strPerfromStr = [NSString stringWithFormat:@"%.2f",(float)indicator.pert_sum];
       if (indicator.pert_sum >= 10000)
       {
           strPerfromStr = [NSString stringWithFormat:@"%.2f万",(float)indicator.pert_sum/10000.0f];
       }
       
       [self.monthPerformance setContentText:strPerfromStr];
       [self.alertBtn setBadge:indicator.alert_count];
       [self.petitionBtn setBadge:indicator.petition_count];
       [self.messageBtn setBadge:indicator.msg_count];
       
       
       
       if (self.indicator.bannerDataArr.count ==0)
       {
           BannerData*data = [[BannerData alloc] init];
           data.imgUrl = @"banner";
           data.webUrl = nil;
           [self.indicator.bannerDataArr addObject:data];
       }
       [self.advertisementPlayer initWithCount:indicator.bannerDataArr.count delegate:self];
   });
}

-(void)updateDic
{
    //[self  showHint:@"正在更新字典表"];
    SHOWHUD_WINDOW;
    [dictionaryManager updateDicSuccess:^(id responseObject) {
        HIDEHUD_WINDOW
        [self.scrollView headerBeginRefreshing];
        [self reloadData];
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW
        
        [WCAlertView showAlertWithTitle:@"更新字典表失败" message:@"请点击重新更新" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            [self updateDic];
        } cancelButtonTitle:@"取消" otherButtonTitles:@"重新更新", nil];
        
    }];
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
        else
        {
            [self.publicAnncTb deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *CellIdentifier = @"MainPageTableViewHeaderCell";
    
    MainPageTableViewHeaderCell *cell=(MainPageTableViewHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger iRow = indexPath.row;
    
    UITableViewCell*cell = nil;
    
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"PublicAnncTableViewCell";
        
        PublicAnncTableViewCell *cell=(PublicAnncTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
            
            [cell initWithTitle:title isNew:NO];
            
        }
        return cell;
    }
    
    
    
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    }
    else
    {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"viewAnncDetails"])
    {
        if ([controller isKindOfClass:[AnncDetailsViewController class]])
        {
            AnncDetailsViewController *detailController = (AnncDetailsViewController *)controller;
            NSIndexPath *selectIndexPath = [self.publicAnncTb indexPathForSelectedRow];
            
            detailController.annc = [self.mainAnncArr objectAtIndex:selectIndexPath.row];
            

        }
       
    }

    
    
}


#pragma mark -
-(void)returnSelection:(NSArray *)curSelection
{
    
}

-(void)initUI
{
    CGRect navFrame = self.navigationController.navigationBar.frame;
    //navFrame.origin.y+navFrame.size.height
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0 , self.view.frame.size.width, self.view.frame.size.height - (navFrame.origin.y+navFrame.size.height))];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+100);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addHeaderWithTarget:self action:@selector(reloadData)];
    
    
    self.advertisementPlayer = [[ImagePlayerView alloc] init];
    self.advertisementPlayer.frame = CGRectMake(0,0, self.scrollView.frame.size.width, self.scrollView.frame.size.width/2.0);
    self.advertisementPlayer.pageControlPosition = ICPageControlPosition_BottomCenter;
    self.advertisementPlayer.scrollInterval = 5;
    

    [self.advertisementPlayer initWithCount:1 delegate:self edgeInsets:UIEdgeInsetsZero];
    [self.scrollView addSubview:self.advertisementPlayer];
    
    CGFloat Y = CGRectGetMaxY(self.advertisementPlayer.frame);
    self.todaysFollow = [[MainPageLabeView alloc] initWithOrig:CGPointMake(0, Y)];
    [self.todaysFollow setLogo:[UIImage imageNamed:@"今日跟进"] Title:@"今日跟进" Content:@""];
    [self.scrollView addSubview:self.todaysFollow];
    
    self.todaysAppointment = [[MainPageLabeView alloc] initWithOrig:CGPointMake(CGRectGetMaxX(self.todaysFollow.frame), Y)];
    [self.todaysAppointment setLogo:[UIImage imageNamed:@"今日带看"] Title:@"今日带看" Content:@""];
    [self.scrollView addSubview:self.todaysAppointment];

    
    self.monthPerformance = [[MainPageLabeView alloc] initWithOrig:CGPointMake(CGRectGetMaxX(self.todaysAppointment.frame), Y)];
    [self.monthPerformance setLogo:[UIImage imageNamed:@"本月业绩"] Title:@"本月业绩" Content:@""];
    [self.scrollView addSubview:self.monthPerformance];
    
    Y = CGRectGetMaxY(self.monthPerformance.frame)+YSPACE*1.5;
    self.alertBtn = [[MainPageButton alloc] initWithOrig:CGPointMake(0, Y)];
    self.petitionBtn = [[MainPageButton alloc] initWithOrig:CGPointMake(CGRectGetMaxX(self.alertBtn.frame), Y)];
    self.messageBtn = [[MainPageButton alloc] initWithOrig:CGPointMake(CGRectGetMaxX(self.petitionBtn.frame), Y)];
    [self.alertBtn setBackgroundColor:ALERTBTN_COLOR Logo:[UIImage imageNamed:@"业务提醒"] Title:@"业务提醒" Badge:0];
    [self.petitionBtn setBackgroundColor:PETITIONBTN_COLOR Logo:[UIImage imageNamed:@"待办签呈"] Title:@"待办签呈" Badge:0];
    [self.messageBtn setBackgroundColor:MSGBTN_COLOR Logo:[UIImage imageNamed:@"站内信"] Title:@"站内信" Badge:0];
    [self.messageBtn.btn addTarget:self action:@selector(leftMsgBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertBtn.btn addTarget:self action:@selector(rightAlertBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.petitionBtn.btn addTarget:self action:@selector(toPetitionListView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.alertBtn];
    [self.scrollView addSubview:self.petitionBtn];
    [self.scrollView addSubview:self.messageBtn];
    
    Y = CGRectGetMaxY(self.messageBtn.frame)+YSPACE*1.5;
    
    CGRect tbBarframe =  self.tabBarController.tabBar.frame;
    

    self.publicAnncTb = [[UITableView alloc] initWithFrame:CGRectMake(0, Y, SCREEN_WIDTH, CGRectGetMinY(tbBarframe)-Y + 100) style:UITableViewStylePlain];
    self.publicAnncTb.delegate = self;
    self.publicAnncTb.dataSource = self;
    self.publicAnncTb.scrollEnabled = NO;
    [self.scrollView addSubview:self.publicAnncTb];
}



#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    if (self.indicator && self.indicator.bannerDataArr && self.indicator.bannerDataArr.count > index)
    {
        
        NSString*str = ((BannerData*)self.indicator.bannerDataArr[index]).imgUrl;
        
        if (str && str.length > 0)
        {
            if ([str isEqualToString:@"banner"])
            {
                [imageView setImage:[UIImage imageNamed:@"banner"]];
            }
            else
            {

                [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"banner.png"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
                    if (error)
                    {
                        imageView.image = [UIImage imageNamed:@"banner_fail.jpg"];
                    }
                    
                }];
            }
            
        }
        
        
    }
    else
    {
        if (self.indicator == nil)
        {
            imageView.image = [UIImage imageNamed:@"banner"];
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"banner_no.jpg"];
        }
        
    }
    
    
    
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    
    if (self.indicator && self.indicator.bannerDataArr && self.indicator.bannerDataArr.count > index)
    {
        NSString*str = ((BannerData*)self.indicator.bannerDataArr[index]).webUrl;
        
        if (str != nil)
        {
            WebViewController*vc = [[WebViewController alloc] init];
            vc.url = str;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        
    }
}

@end
