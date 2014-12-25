//
//  orderTableViewController.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "orderTableViewController.h"
#import "orderTableViewCell.h"
#import "BFNavigationBarDrawer.h"
#import "shopBizManager.h"
#import "UtilFun.h"
#import "order.h"
#import "editOrderViewController.h"

@interface orderTableViewController ()
{
    BFNavigationBarDrawer *drawer;
    UIBarButtonItem *buttonModify;
    UIBarButtonItem *btnCancel;
    UIBarButtonItem *btnReceive;
    BOOL needRefreshData;
}

@end

@implementation orderTableViewController

@synthesize shopItemArr;
@synthesize selectArr;
@synthesize shopType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    needRefreshData= NO;
    selectArr = [[NSMutableArray alloc ] init];
    self.shopItemArr = [[NSMutableArray alloc ] init];
    [self initNavigationBar];
    
    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideDrawer];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (needRefreshData)
    {
        [shopItemArr removeAllObjects];
        [self getData];
    }
}

-(void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"订单管理";
    
    
    drawer = [[BFNavigationBarDrawer alloc] init];
    
    drawer.scrollView = self.tableView;
    
    buttonModify = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(modifyOrder:)];
    
    btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelOrder:)];
    
    UIBarButtonItem *itemButtonEmpty1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *itemButtonEmpty2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    btnReceive = [[UIBarButtonItem alloc] initWithTitle:@"收货" style:UIBarButtonItemStylePlain target:self action:@selector(receiveOrder:)];
    buttonModify.enabled = NO;
    btnCancel.enabled = NO;
    btnReceive.enabled = NO;
    
    
    drawer.items = @[buttonModify,itemButtonEmpty1,btnCancel,itemButtonEmpty2,btnReceive];
    
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
    
    [shopBizManager getAllKindsOrderListByType:self.shopType From:from To:@"" Count:1000 Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.shopItemArr addObjectsFromArray:responseObject];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
    
}

-(void)modifyOrder:(id)sender
{
    [self hideDrawer];
    needRefreshData = NO;
    [self performSegueWithIdentifier:@"showEditOrderView" sender:self];
}
-(void)cancelOrder:(id)sender
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
-(void)receiveOrder:(id)sender
{
    if (selectArr.count ==0)
    {
        [self hideDrawer];
        return;
    }
    SHOWHUD(self.view);
    [shopBizManager receiveOrder:self.selectArr Success:^(id responseObject) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setActionBarStatus
{
    NSInteger selectedCnt = selectArr.count;
    if (selectedCnt == 0)
    {
        buttonModify.enabled = NO;
        btnCancel.enabled = NO;
        btnReceive.enabled = NO;
    }
    else if(selectedCnt == 1)
    {
        order*order = [selectArr objectAtIndex:0];
        if ([order canEdit])
        {
            buttonModify.enabled = YES;
            btnCancel.enabled = YES;
            btnReceive.enabled = NO;
        }
        else if([order canCancel])
        {
            buttonModify.enabled = YES;
            btnCancel.enabled = YES;
            btnReceive.enabled = NO;
        }
        else if([order canReceive])
        {
            buttonModify.enabled = NO;
            btnCancel.enabled = NO;
            btnReceive.enabled = YES;
        }
        else
        {
            buttonModify.enabled = NO;
            btnCancel.enabled = NO;
            btnReceive.enabled = NO;
        }
    }
    else
    {
        BOOL canAction = YES;
        for (int i = 0; i < selectArr.count; i++)
        {
            order*odr = [selectArr objectAtIndex:i];
            
            for (int j = 1; j < selectArr.count; j++)
            {
                order*odr1 = [selectArr objectAtIndex:j];
                if ([odr.bill_state intValue] != [odr1.bill_state intValue])
                {
                    canAction = NO;
                    break;
                }
                
            }
            if (canAction == NO)
            {
                break;
            }
            
            if ([odr canEdit])
            {
                btnCancel.enabled = YES;
            }
            else if([odr canCancel])
            {
                btnCancel.enabled = YES;
            }
            else if([odr canReceive])
            {
                btnCancel.enabled = NO;
            }
            else
            {
                btnCancel.enabled = NO;
            }
        }
        
        if (canAction == NO)
        {
            btnCancel.enabled = NO;
        }
        
        buttonModify.enabled = NO;
        btnReceive.enabled = NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"---------------------------select,row=%ld",indexPath.row);
    
    
    [selectArr addObject:[shopItemArr objectAtIndex:indexPath.row]];
    [self setActionBarStatus];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"----------deselect,row=%ld",indexPath.row);
    [selectArr removeObject:[shopItemArr objectAtIndex:indexPath.row]];
    [self setActionBarStatus];
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
    orderTableViewCell *cell = ( orderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"orderTableViewCell" forIndexPath:indexPath];
    
    order*order = [shopItemArr objectAtIndex:indexPath.row];
    if (order)
    {
        cell.oderByPerson.text = [NSString stringWithFormat:@"订购人:  %@",order.name_full];
        cell.goodName.text = [NSString stringWithFormat:@"物品名称:  %@",order.bill_name];
        cell.goodType.text = [NSString stringWithFormat:@"物品规格:  %@",order.bill_spec];//order.bill_spec;
        cell.price.text = [NSString stringWithFormat:@"物品价格:  %@",order.bill_price];//order.bill_price;
        cell.count.text = [NSString stringWithFormat:@"购买数量:  %@",order.bill_num];//order.bill_num;
        cell.total.text = [NSString stringWithFormat:@"共计金额:  %@",order.bill_sum];//order.bill_sum;
        cell.date.text = [NSString stringWithFormat:@"订单日期:  %@",order.bill_date];//order.bill_date;
        cell.status.text = [NSString stringWithFormat:@"订单状态:  %@",[order getStatusString]];//[order getStatusString];
        cell.sendDate.text = [NSString stringWithFormat:@"配送日期:  %@",order.distribution_date];//[order getStatusString];
        cell.receiveDate.text = [NSString stringWithFormat:@"收货日期:  %@",order.goods_time];//[order getStatusString];
        
    }
    
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



-(void)dataHasEditd
{
    needRefreshData = YES;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"showEditOrderView"])
    {
        if ([controller isKindOfClass:[editOrderViewController class]])
        {
            editOrderViewController *ctrl = (editOrderViewController *)controller;
            
            ctrl.odr = [self.selectArr objectAtIndex:0];
            ctrl.delegate = self;
            [self clearSelection];
            
        }
        else
        {
            
        }
        
    }

}


@end
