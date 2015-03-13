//
//  FollowTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "FollowTableViewController.h"
#import "MJRefresh.h"
#import "UtilFun.h"
#import "FollowDataPuller.h"
#import "FollowAddController.h"
#import "FollowDetailCell.h"
#import "UtilFun.h"

@interface FollowTableViewController ()

@property (nonatomic, strong) NSMutableArray *followList;

@end

@implementation FollowTableViewController

@synthesize hasAddPermit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"跟进列表";
    
    // init data
    self.followList = [NSMutableArray array];
    
    // add title button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onAddAction:)];

    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
}

- (void)onAddAction:(id)sender
{
    if (!hasAddPermit)
    {
        PRESENTALERT(@"添加失败", @"对不起,您没有权限新增跟进!", @"OK", self);
        return;
    }
    FollowAddController *vc = [[FollowAddController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.sid = self.sid;
    vc.type = self.type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    // clear
    [self.followList removeAllObjects];
    // get
    SHOWHUD_WINDOW;
    [FollowDataPuller pullDataWithFilter:self.sid Success:^(NSArray *followList)
    {
        HIDEHUD_WINDOW;
        [self.followList addObjectsFromArray:followList];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }
                                failure:^(NSError *e)
    {
        HIDEHUD_WINDOW;
        [self.tableView headerEndRefreshing];
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
    return self.followList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FollowDetailCell";
    FollowDetailCell *cell = (FollowDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FollowDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[FollowDetailCell class]])
            {
                cell = (FollowDetailCell *)oneObject;
            }
        }
    }
  
    NSDictionary *d = [self.followList objectAtIndex:indexPath.row];
    cell.type.text = [d objectForKey:@"task_type_label"];
    cell.remind.text = [[d objectForKey:@"task_reminder_flg"] isEqualToString:@"1"] ? @"是" : @"否";
    cell.man.text = [d objectForKey:@"name_full"];
    cell.time.text = [d objectForKey:@"task_follow_time"];
    cell.content.text = [d objectForKey:@"task_follow_content"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
