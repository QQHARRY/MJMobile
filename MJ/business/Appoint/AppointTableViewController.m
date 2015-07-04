//
//  AppointTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AppointTableViewController.h"
#import "MJRefresh.h"
#import "UtilFun.h"
#import "AppointDataPuller.h"
#import "AppointDetailCell.h"
#import "dictionaryManager.h"
#import "Macro.h"

@interface AppointTableViewController ()

@property (nonatomic, strong) NSMutableArray *AppointList;
@property (nonatomic, strong) NSArray *appointDictList;

@end

@implementation AppointTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"带看列表";
    
    // init data
    self.AppointList = [NSMutableArray array];
    
    // get dict
    self.appointDictList = [dictionaryManager getItemArrByType:DIC_APPOINT_EVALUATE];

    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)refreshData
{
    // clear
    [self.AppointList removeAllObjects];
    // get
    SHOWHUD_WINDOW;
    [AppointDataPuller pullDataWithFilter:self.sid Success:^(NSArray *AppointList)
    {
        HIDEHUD_WINDOW;
        [self.AppointList addObjectsFromArray:AppointList];
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
    return self.AppointList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AppointDetailCell";
    AppointDetailCell *cell = (AppointDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AppointDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[AppointDetailCell class]])
            {
                cell = (AppointDetailCell *)oneObject;
            }
        }
    }
  
    NSDictionary *d = [self.AppointList objectAtIndex:indexPath.row];
    cell.object.text = [d objectForKey:@"appoint_obj_name"];
    cell.content.text = [d objectForKey:@"appoint_content"];
    cell.dept.text = [d objectForKey:@"appoint_content"];
    cell.man.text = [d objectForKey:@"appoint_person_name"];
    cell.time.text = [d objectForKey:@"appoint_time"];
    for (DicItem *di in self.appointDictList)
    {
        if ([di.dict_value isEqualToString:[d objectForKey:@"appoint_evaluate"]])
        {
            cell.rank.text = di.dict_label;
            break;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end




