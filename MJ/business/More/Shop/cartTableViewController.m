//
//  cartTableViewController.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "cartTableViewController.h"
#import "UtilFun.h"
#import "shopBizManager.h"
#import "order.h"
#import "cartTableViewCell.h"
#import "BFNavigationBarDrawer.h"
#import "UtilFun.h"
#import "Macro.h"

@interface cartTableViewController ()
{
    BFNavigationBarDrawer *drawer;
}

@end

@implementation cartTableViewController
@synthesize shopItemArr;
@synthesize selectArr;
@synthesize shopType;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    selectArr = [[NSMutableArray alloc ] init];
    self.shopItemArr = [[NSMutableArray alloc ] init];
    [self initNavigationBar];
    
    
    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideDrawer];
}
-(void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"订单管理";
    
    
    drawer = [[BFNavigationBarDrawer alloc] init];
    
    drawer.scrollView = self.tableView;
    
    
    UIBarButtonItem *btnSelectAll = [[UIBarButtonItem alloc] initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(deleteOrderBtn:)];

    UIBarButtonItem *itemButtonEmpty = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *btnSetReaded = [[UIBarButtonItem alloc] initWithTitle:@"下单" style:UIBarButtonItemStylePlain target:self action:@selector(confirmOrderBtn:)];
    drawer.items = @[btnSetReaded,itemButtonEmpty,btnSelectAll];
    
}



-(void)deleteOrderBtn:(id)sender
{
    
    if (selectArr.count ==0)
    {
        [self hideDrawer];
        return;
    }
    SHOWHUD(self.view);
    [shopBizManager cancelOrder:self.selectArr Success:^(id responseObject) {
        [self clearSelection];
        [shopItemArr removeAllObjects];
        HIDEHUD(self.view);
        [self getData];
        
    } failure:^(NSError *error) {
        [self clearSelection];
        HIDEHUD(self.view);
    }];
    
    [self hideDrawer];
}

-(void)confirmOrderBtn:(id)sender
{
    
    if (selectArr.count ==0)
    {
        [self hideDrawer];
        return;
    }
    SHOWHUD(self.view);
    [shopBizManager confirmOrder:self.selectArr Success:^(id responseObject) {
        [self clearSelection];
        [shopItemArr removeAllObjects];
        HIDEHUD(self.view);
        [self getData];
        
    } failure:^(NSError *error) {
        [self clearSelection];
        HIDEHUD(self.view);
        NSString*errorStr = [NSString stringWithFormat:@"%@",error];
        
        PRSENTALERT(SERVER_NONCOMPLIANCE,errorStr,@"OK",self);
    }];
    [self hideDrawer];
}

-(void)clearSelection
{
    [selectArr removeAllObjects];
}
-(void)showDrawer
{
    [super setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem.title = @"取消";
    self.tableView.editing = YES;
    
    [drawer showFromNavigationBar:self.navigationController.navigationBar animated:YES];
}



-(void)hideDrawer
{
    [super setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem.title = @"订单管理";
    self.tableView.editing = NO;
    [drawer hideAnimated:YES];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (editing)
    {
        [self clearSelection];
        [self showDrawer];
    }
    else
    {
        [self clearSelection];
        [self hideDrawer];
    }
    
}

-(void)getData
{
    SHOWHUD(self.view);
    NSString*from = @"0";
    if ([self.shopItemArr count] > 0)
    {
        shopItem*obj = [self.shopItemArr objectAtIndex:self.shopItemArr.count-1];
        from = obj.goods_no;
    }
    
    [shopBizManager getOrderListByType:self.shopType From:from To:@"" Count:1000 Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.shopItemArr addObjectsFromArray:responseObject];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectArr addObject:[shopItemArr objectAtIndex:indexPath.row]];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectArr removeObject:[shopItemArr objectAtIndex:indexPath.row]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return shopItemArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cartTableViewCell *cell = (cartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cartTableViewCell" forIndexPath:indexPath];
    
    order*order = [shopItemArr objectAtIndex:indexPath.row];
    if (order)
    {
        cell.goodName.text = [NSString stringWithFormat:@"物品名称:  %@",order.bill_name];
        cell.goodType.text = [NSString stringWithFormat:@"物品规格:  %@",order.bill_spec];//order.bill_spec;
        cell.price.text = [NSString stringWithFormat:@"物品价格:  %@",order.bill_price];//order.bill_price;
        cell.count.text = [NSString stringWithFormat:@"购买数量:  %@",order.bill_num];//order.bill_num;
        cell.total.text = [NSString stringWithFormat:@"共计金额:  %@",order.bill_sum];//order.bill_sum;
        cell.date.text = [NSString stringWithFormat:@"订单日期:  %@",order.bill_date];//order.bill_date;
        cell.status.text = [NSString stringWithFormat:@"订单状态:  %@",[order getStatusString]];//[order getStatusString];
    }
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
