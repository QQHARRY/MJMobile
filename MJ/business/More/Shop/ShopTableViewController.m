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

@interface ShopTableViewController ()

@end

@implementation ShopTableViewController
@synthesize shopItemArr;
@synthesize shopType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shopItemArr = [[NSMutableArray alloc] init];

    [self getData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"购物车" style:UIBarButtonItemStylePlain target:self action:@selector(cartButtonClicked:)];
}

-(void)cartButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"shouShopCart" sender:self];
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

    [shopBizManager getListByType:self.shopType From:from To:@"" Count:1000 Success:^(id responseObject) {
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
        
        [cell.indicatorDn  startAnimating];
        NSString*strUrl = [SERVER_ADD stringByAppendingString:obj.photo_file_name];
        [cell.goodImage setImageWithURL:[NSURL URLWithString:strUrl]];
    }
    
    return cell;
}

-(void)addShopItemToCart:(shopItem*)item Count:(NSInteger)count TotalPrice:(CGFloat)price
{
    SHOWHUD(self.view);
    [shopBizManager addToCartByBillType:self.shopType GoodID:item.goods_no BillNum:count Success:^(id responseObject) {
        
        [self.shopItemArr  removeAllObjects];
        HIDEHUD(self.view);
        [self getData];
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
