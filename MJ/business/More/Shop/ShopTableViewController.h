//
//  ShopTableViewController.h
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopItemTableViewCell.h"

typedef NS_ENUM(NSInteger, MJShopType) {
    PERSONALSHOP       = 1,
    DEPARTMENTSHOP     = 2,
};

@interface ShopTableViewController : UITableViewController<buyShopItemDelegate>

@property(nonatomic,strong)NSMutableArray*shopItemArr;

@property(nonatomic,assign)MJShopType shopType;


-(void)addShopItemToCart:(shopItem*)item Count:(NSInteger)count TotalPrice:(CGFloat)price;
@end
