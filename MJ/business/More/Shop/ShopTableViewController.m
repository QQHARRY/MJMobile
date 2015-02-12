//
//  ShopTableViewController.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ShopTableViewController.h"
#import "ShopItemTableViewCell.h"
#import "UtilFun.h"

#import "shopBizManager.h"
#import "UIImageView+AFNetworking.h"
#import "Macro.h"
#import "cartTableViewController.h"
#import "MJRefresh.h"

@interface ShopTableViewController ()

@end

@implementation ShopTableViewController
@synthesize shopItemArr;
@synthesize shopType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shopItemArr = [[NSMutableArray alloc] init];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(cartButtonClicked:)];
    
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    
    [self getData:YES];
}

-(void)refreshData
{
    [self clearData];
    [self getData:NO];
}

-(void)loadMore
{
    [self getData:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self clearData];
    //[self getData];
}
-(void)clearData
{
    [self.shopItemArr removeAllObjects];
}



-(void)endRefreshing:(BOOL)isFoot
{
    if (isFoot)
    {
        [self.tableView footerEndRefreshing];
    }
    else
    {
        [self.tableView headerEndRefreshing];
    }
    
}

-(void)cartButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"shouShopCart" sender:self];
}

-(void)getData:(BOOL)isFoot
{
    SHOWHUD(self.view);
    NSString*from = @"0";
    if ([self.shopItemArr count] > 0)
    {
        shopItem*obj = [self.shopItemArr objectAtIndex:self.shopItemArr.count-1];
        from = obj.goods_no;
    }

    [shopBizManager getListByType:self.shopType From:from To:@"" Count:4 Success:^(id responseObject) {
        HIDEHUD(self.view);
        [self.shopItemArr addObjectsFromArray:responseObject];
        
        [self.tableView setContentSize:CGSizeMake(self.view.frame.size.width, 100*self.shopItemArr.count+44)];
        [self.tableView reloadData];
        [self endRefreshing:isFoot];
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
        [self endRefreshing:isFoot];
    }];
    
}

//-(void)getData:(BOOL)isFoot
//{
//    SHOWHUD(self.view);
//    NSString*from = @"0";
//    if ([self.msgArr count] > 0)
//    {
//        messageObj*obj = [self.msgArr objectAtIndex:self.msgArr.count-1];
//        from = obj.msg_cno;
//    }
//    
//    [messageManager getMsgByType:self.msgType ListFrom:from To:@"" Count:8 Success:^(id responseObject) {
//        HIDEHUD(self.view);
//        [self.msgArr addObjectsFromArray:responseObject];
//        
//        [self.tableView reloadData];
//        [self endRefreshing:isFoot];
//        
//    } failure:^(NSError *error) {
//        HIDEHUD(self.view);
//        [self endRefreshing:isFoot];
//    }];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    // Return the number of rows in the section.
    NSInteger count =  [shopItemArr count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopItemTableViewCell *cell = (ShopItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"shopItemTableViewCell" forIndexPath:indexPath];
    
    
//    NSString*key = @"shopItemTableViewCell";
//    ShopItemTableViewCell *cell = nil;
//    if (!cell)
//    {
//        cell = [[ShopItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
//    }
    
    
    
    cell.goodImage.image = [UIImage imageNamed:@"goods"];
    if (indexPath.row < shopItemArr.count)
    {
        shopItem*obj = [shopItemArr objectAtIndex:indexPath.row];
        if (obj)
        {
            cell.item = obj;
            cell.delegate = self;
            NSString*str = @"商品名称:";
            str = [str stringByAppendingString:obj.goods_name];
            cell.goodName.text = str;
            str = @"规格:";
            str = [str stringByAppendingString:obj.goods_spec];
            cell.goodType.text = str;
            str = @"价格:";
            str = [str stringByAppendingString:obj.goods_price];
            str = [str stringByAppendingString:@"元"];
            cell.goodPrice.text = str;
            str = @"库存数量:";
            str = [str stringByAppendingString:obj.goods_num];
            str = [str stringByAppendingString:obj.goods_unit];
            cell.totalCountRestore.text = str;
            cell.totalCountSelected.text = @"0";
            str = @"订购金额:0元";
            cell.goodTotalPrice.text = str;
            
            
            cell.selectedCount = 0;
            cell.unitPrice = [obj.goods_price floatValue];
            cell.totalPrice = 0;
            cell.maximunNumInStore = [obj.goods_num intValue];
            
            NSString*strUrl = [SERVER_ADD stringByAppendingString:obj.photo_file_name];
            
            [cell downLoadImage:[NSURL URLWithString:strUrl]];
//            NSLog(@"strUrl = %@",strUrl);
//            [cell.goodImage getImageWithURL:[NSURL URLWithString:strUrl] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                cell.goodImage.image = image;
//                NSLog(@"load image from %@ success",request.URL.absoluteString);
//                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                NSLog(@"load image from %@ fail",request.URL.absoluteString);
//            }];
            //[cell.goodImage setImageWithURL:[NSURL URLWithString:strUrl]];
        }

    }
    
    return cell;
}

-(void)addShopItemToCart:(shopItem*)item Count:(NSInteger)count TotalPrice:(CGFloat)price
{
    SHOWHUD(self.view);
    [shopBizManager addToCartByBillType:self.shopType GoodID:item.goods_no BillNum:count Success:^(id responseObject) {
        
        [self.shopItemArr  removeAllObjects];
        HIDEHUD(self.view);
        [self refreshData];
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
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
    
    
    if ([segue.identifier isEqual:@"shouShopCart"])
    {
        if ([controller isKindOfClass:[cartTableViewController class]])
        {
            cartTableViewController *ctrl = (cartTableViewController *)controller;
            
            ctrl.shopType = self.shopType;
            
            
        }
        else
        {
            
        }
        
    }

}


@end
