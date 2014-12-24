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



@end
