//
//  CustomerSecret.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface CustomerSecret : dic2Object

@property(nonatomic,strong) NSString *obj_mobile;
@property(nonatomic,strong) NSString *obj_fixtel;
@property(nonatomic,strong) NSString *client_identity;
@property(nonatomic,strong) NSString *obj_address;

@end
