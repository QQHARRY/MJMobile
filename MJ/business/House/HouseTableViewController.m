//
//  HouseTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseTableViewController.h"
#import "HouseDataPuller.h"
#import "UtilFun.h"
#import "HouseDetailCell.h"

@interface HouseTableViewController ()

@property (nonatomic, strong) NSMutableArray *houseList;

@end

@implementation HouseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init data
    self.houseList = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    // clear
    [self.houseList removeAllObjects];
    // get
     SHOWHUD([UIApplication sharedApplication].keyWindow);
    [HouseDataPuller pullDataWithFilter:self.filter Success:^(NSArray *houseDetailList)
    {
        HIDEHUD([UIApplication sharedApplication].keyWindow);
        [self.houseList addObjectsFromArray:houseDetailList];
        [self.tableView reloadData];
    }
                                failure:^(NSError *e)
    {
        HIDEHUD([UIApplication sharedApplication].keyWindow);
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
    return self.houseList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HouseDetailCell";
    HouseDetailCell *cell=(HouseDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray *nibs=[[NSBundle mainBundle] loadNibNamed:@"HouseDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[HouseDetailCell class]])
            {
                cell = (HouseDetailCell *)oneObject;
            }
        }
    }
    //
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //
    //    messageObj*obj = [msgArr objectAtIndex:indexPath.row];
    //    if (obj)
    //    {
    //        cell.receiver.text = obj.msg_opt_user_list_name;
    //        cell.msgSender.text = obj.view_user_list_name;
    //        cell.briefContent.text = obj.msg_title;
    //        cell.sendTime.text = obj.msg_save_date;
    //    }
    //    
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    messageObj*obj = [msgArr objectAtIndex:indexPath.row];
//    MessageDetailsViewController*detailsView = [[MessageDetailsViewController alloc ] initWithNibName:@"MessageDetailsViewController" bundle:[NSBundle mainBundle]];
//    
//    detailsView.msg = obj;
//    [self pushControllerToController:detailsView];
}

-(void)pushControllerToController:(UIViewController*)vc
{
//    if ([self.navigationController respondsToSelector:@selector(pushViewController:animated:)])
//    {
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//    
//    if ([((UIViewController*)(self.container)).navigationController respondsToSelector:@selector(pushViewController:animated:)])
//    {
//        [((UIViewController*)(self.container)).navigationController pushViewController:vc animated:YES];
//    }
}



@end
