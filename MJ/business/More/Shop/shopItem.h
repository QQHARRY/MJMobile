//
//  shopItem.h
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface shopItem : dic2Object



@property (strong, nonatomic)  NSString *goods_no;
@property (strong, nonatomic)  NSString *goods_name;
@property (strong, nonatomic)  NSString *goods_spec;
@property (strong, nonatomic)  NSString *goods_price;
@property (strong, nonatomic)  NSString *goods_unit;
@property (strong, nonatomic)  NSString *goods_num;
@property (strong, nonatomic)  NSString *photo_file_name;
@property (strong, nonatomic)  NSString *remark_info;
@property (assign, nonatomic)  double good_unit_price;



@end
