//
//  cartTableViewController.h
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopTableViewController.h"


@interface cartTableViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray*shopItemArr;
@property(nonatomic,strong)NSMutableArray*selectArr;
@property(nonatomic,assign)MJShopType shopType;

@end
