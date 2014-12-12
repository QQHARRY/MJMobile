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

@interface MainPageViewController ()

@end


@implementation MainPageViewController


#pragma mark initView
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    [self initBadgeNavBarWithUnReadAlertCount:0 andMsgCount:0];
    [self initTable];
    [self loadData];
}

-(void)initBadgeNavBarWithUnReadAlertCount:(int)alertCnt andMsgCount:(int)msgCnt
{
    NSString*unReadAlertStr =(alertCnt<=0)?@"":[NSString stringWithFormat:@"%d",alertCnt];
    NSString*unReadMsgStr =(msgCnt<=0)?@"":[NSString stringWithFormat:@"%d",msgCnt];

    
    UIImage*alertImage = [badgeImageFactory getBadgeImageFromImage:[UIImage imageNamed:@"unreadAlert"] andText:unReadAlertStr];
    UIImage*msgImage = [badgeImageFactory getBadgeImageFromImage:[UIImage imageNamed:@"unreadMessage"] andText:unReadMsgStr];
    
    
    [self setupLeftMenuButtonOfVC:self Image:msgImage action:@selector(leftMsgBtnSelected:)];
    [self setupRightMenuButtonOfVC:self Image:alertImage action:@selector(rightAlertBtnSelected:)];
}


-(void)initTable
{
    
    //self.tableView = [[UITableView alloc ] initWithFrame:self.view.frame];
    //self.tableView.delegate = self;
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
        self.mainPetitionArr = responseObject;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
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
        if (self.mainAnncArr)
        {
            announcement*annc = [self.mainAnncArr objectAtIndex:indexPath.row];
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
        if (self.mainPetitionArr)
        {
            petiotionBrief*ptionBr = [self.mainPetitionArr objectAtIndex:indexPath.row];
            if (ptionBr)
            {
                cell.type.text = ptionBr.flowtype;
                cell.reason.text = ptionBr.flowtype;
                cell.person.text = ptionBr.username;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"公告";
    }
    else if(section == 1)
    {
        return @"签程";
    }
    return @"";
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
    
}

-(void)rightAlertBtnSelected:(id)sender
{
    
}
#pragma mark -



#pragma mark other

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

#pragma mark -

@end
