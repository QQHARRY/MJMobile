//
//  order.h
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "bizManager.h"
#import "dic2Object.h"

typedef NS_ENUM(NSInteger, MJShopOderAction) {
    MJSHOPORDERACTION_EDIT,
    MJSHOPORDERACTION_CANCEL,
    MJSHOPORDERACTION_RECEIVE
};


@interface order : dic2Object

@property(strong,nonatomic)NSString*bill_no;
@property(strong,nonatomic)NSString*bill_name;
@property(strong,nonatomic)NSString*bill_spec;
@property(strong,nonatomic)NSString*bill_price;
@property(strong,nonatomic)NSString*bill_num;
@property(strong,nonatomic)NSString*bill_sum;
@property(strong,nonatomic)NSString*bill_date;
@property(strong,nonatomic)NSString*bill_state;
@property(strong,nonatomic)NSString*bill_state_label;

@property(strong,nonatomic)NSString*name_full;
@property(strong,nonatomic)NSString*dept_name;
@property(strong,nonatomic)NSString*goods_num;
@property(strong,nonatomic)NSString*distribution_date;
@property(strong,nonatomic)NSString*goods_time;


-(NSString*)getStatusString;

-(BOOL)canEdit;
-(BOOL)canCancel;
-(BOOL)canReceive;


-(NSString*)promptWithAction:(MJShopOderAction)action;






@end
