//
//  shopRootTableViewController.m
//  MJ
//
//  Created by harry on 14/12/22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "shopRootTableViewController.h"
#import "orderTableViewController.h"


@interface shopRootTableViewController ()

@end

@implementation shopRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString*key = @"shopRootTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"个人物品信息";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"门店物品信息";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"个人物品订单";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"门店物品订单";
        }
            break;
            
        default:
            break;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            self.wantShopType = PERSONALSHOP;
            [self performSegueWithIdentifier:@"showShopByType" sender:self];
            
        }
            break;
        case 1:
        {
            self.wantShopType = DEPARTMENTSHOP;
            [self performSegueWithIdentifier:@"showShopByType" sender:self];
            
        }
            break;
        case 2:
        {
            self.wantShopType = PERSONALSHOP;
            [self performSegueWithIdentifier:@"showOrderList" sender:self];
        }
            break;
        case 3:
        {
            self.wantShopType = DEPARTMENTSHOP;
            [self performSegueWithIdentifier:@"showOrderList" sender:self];
        }
            break;
            
        default:
            break;
    }
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
    
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    
    if ([segue.identifier isEqual:@"showShopByType"])
    {
        if ([controller isKindOfClass:[ShopTableViewController class]])
        {
            ShopTableViewController *ctrl = (ShopTableViewController *)controller;

            ctrl.shopType = self.wantShopType;
            
            
        }
        else
        {
            
        }
        
    }
    else if ([segue.identifier isEqual:@"showOrderList"])
    {
        if ([controller isKindOfClass:[orderTableViewController class]])
        {
            orderTableViewController *ctrl = (orderTableViewController *)controller;
            
            ctrl.shopType = self.wantShopType;
            
            
        }
        else
        {
            
        }
        
    }
    
    
}


@end
