//
//  SignTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "SignTableViewController.h"
#import "MJRefresh.h"
#import "UtilFun.h"
#import "SignDataPuller.h"
#import "SignDetailCell.h"

@interface SignTableViewController ()

@property (nonatomic, strong) NSMutableArray *signList;

@end

@implementation SignTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"预约签约";
    
    // init data
    self.signList = [NSMutableArray array];

    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    // clear
    [self.signList removeAllObjects];
    // get
    SHOWHUD_WINDOW;
    [SignDataPuller pullMySignListWithFrom:@"0" To:@"0" Success:^(NSArray *signList)
    {
        HIDEHUD_WINDOW;
        [self.signList addObjectsFromArray:signList];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }
                                failure:^(NSError *e)
    {
        HIDEHUD_WINDOW;
        [self.tableView headerEndRefreshing];
    }];
}

-(void)loadMore
{
    // reset
    NSDictionary *d = [self.signList lastObject];
    NSString *fid = [d objectForKey:@"client_base_no"];
    // get
    SHOWHUD_WINDOW;
    [SignDataPuller pullMySignListWithFrom:fid To:@"0" Success:^(NSArray *signList)
     {
         HIDEHUD_WINDOW;
         [self.signList addObjectsFromArray:signList];
         [self.tableView reloadData];
         [self.tableView footerEndRefreshing];
     }
                                 failure:^(NSError *e)
     {
         HIDEHUD_WINDOW;
         [self.tableView footerEndRefreshing];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.signList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 212;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SignDetailCell";
    SignDetailCell *cell = (SignDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SignDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[SignDetailCell class]])
            {
                cell = (SignDetailCell *)oneObject;
            }
        }
    }
  
    NSDictionary *d = [self.signList objectAtIndex:indexPath.row];
    cell.no.text = [d objectForKey:@"meeting_sign_apply_no"];
    cell.tno.text = [d objectForKey:@"buiding_no"];
    cell.addr.text = [d objectForKey:@"building_name"];
    cell.apper.text = [d objectForKey:@"person_apply_name"];
    cell.room.text = [d objectForKey:@"room_name"];
    cell.time.text = [d objectForKey:@"apply_date"];
    cell.block.text = [d objectForKey:@"apply_time"];
    cell.dept.text = [d objectForKey:@"dept_name"];
    cell.signer.text = [d objectForKey:@"person_name"];
    NSString *s = [d objectForKey:@"apply_status"];
    if ([s isEqualToString:@"0"])
    {
        cell.status.text = @"待审核";
    }
    else if ([s isEqualToString:@"1"])
    {
        cell.status.text = @"审核通过";
    }
    else if ([s isEqualToString:@"2"])
    {
        cell.status.text = @"签约完成";
    }
    else
    {
        cell.status.text = @"未知";
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
