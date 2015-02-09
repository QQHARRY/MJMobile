//
//  ShopItemTableViewCell.h
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopItem.h"


@protocol buyShopItemDelegate<NSObject>

-(void)addShopItemToCart:(shopItem*)item Count:(NSInteger)count TotalPrice:(CGFloat)price;

@end


@interface ShopItemTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *goodImage;


@property (strong, nonatomic) IBOutlet UILabel *goodName;
@property (strong, nonatomic) IBOutlet UILabel *goodType;
@property (strong, nonatomic) IBOutlet UILabel *goodPrice;
@property (strong, nonatomic) IBOutlet UILabel *goodTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *totalCountRestore;
@property (strong, nonatomic) IBOutlet UITextField *totalCountSelected;


@property (strong, nonatomic) shopItem*item;
@property (assign, nonatomic) id<buyShopItemDelegate>delegate;

@property(assign, nonatomic)CGFloat unitPrice;
@property (assign, nonatomic)CGFloat totalPrice;
@property (assign, nonatomic)NSInteger selectedCount;
@property(assign, nonatomic)NSInteger maximunNumInStore;


-(void)downLoadImage:(NSURL*)url;



- (IBAction)subBtnClicked:(id)sender;
- (IBAction)addBtnClicked:(id)sender;
- (IBAction)BuyBtnClicked:(id)sender;

@end
