//
//  order.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "order.h"

@implementation order

@synthesize bill_no;
@synthesize bill_name;
@synthesize bill_spec;
@synthesize bill_price;
@synthesize bill_num;
@synthesize bill_sum;
@synthesize bill_date;
@synthesize bill_state;
@synthesize bill_state_label;

@synthesize name_full;
@synthesize dept_name;
@synthesize goods_num;
@synthesize distribution_date;
@synthesize goods_time;



-(NSString*)getStatusString
{
    NSDictionary*dic = @{@"0":@"未下单",
                         @"1":@"待发货",
                         @"2":@"已收货",
                         @"3":@"已发货",
                         @"4":@"已取消",
                         };
    
    return [dic objectForKey:self.bill_state];
}

-(BOOL)canEdit
{
    NSInteger status = [self.bill_state intValue];
    return status == 0;
}
-(BOOL)canCancel
{
    NSInteger status = [self.bill_state intValue];
    return status == 0;
}
-(BOOL)canReceive
{
    NSInteger status = [self.bill_state intValue];
    return status == 3;
}


-(NSString*)promptWithAction:(MJShopOderAction)action
{
    NSInteger status = [self.bill_state intValue];
    NSString*promptStr = @"";
    switch (status)
    {
        case 0:
        {
            NSString*tmp = @"该订单尚未下单,";
            switch (action)
            {
                case MJSHOPORDERACTION_EDIT:
                {
                    
                }
                    break;
                case MJSHOPORDERACTION_CANCEL:
                {
                    
                }
                    break;
                case MJSHOPORDERACTION_RECEIVE:
                {
                    NSString*actionStr = @"不能选择收货";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            NSString*tmp = @"该订单已经下单,正在等待发货,";
            switch (action)
            {
                case MJSHOPORDERACTION_EDIT:
                {
                    NSString*actionStr = @"不能编辑订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_CANCEL:
                {
                    NSString*actionStr = @"不能取消订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_RECEIVE:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            NSString*tmp = @"该订单已经收货,";
            switch (action)
            {
                case MJSHOPORDERACTION_EDIT:
                {
                    NSString*actionStr = @"不能编辑订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_CANCEL:
                {
                    NSString*actionStr = @"不能取消订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_RECEIVE:
                {
                    NSString*actionStr = @"不能重复收货";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            NSString*tmp = @"该订单已经发货,";
            switch (action)
            {
                case MJSHOPORDERACTION_EDIT:
                {
                    NSString*actionStr = @"不能编辑订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_CANCEL:
                {
                    NSString*actionStr = @"不能取消订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_RECEIVE:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            NSString*tmp = @"该订单已经取消,";
            switch (action)
            {
                case MJSHOPORDERACTION_EDIT:
                {
                    NSString*actionStr = @"不能编辑订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_CANCEL:
                {
                    NSString*actionStr = @"不能重复取消订单";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                case MJSHOPORDERACTION_RECEIVE:
                {
                    NSString*actionStr = @"不能收货";
                    promptStr = [tmp stringByAppendingPathComponent:actionStr];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return promptStr;
}

@end
