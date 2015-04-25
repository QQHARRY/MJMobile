//
//  department.h
//  MJ
//
//  Created by harry on 14/12/15.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unit.h"
@interface department: unit

@property(strong,nonatomic)NSString*dept_current_no;
@property(strong,nonatomic)NSString*dept_name;
@property(strong,nonatomic)NSString*dept_parent_no;
@property(strong,nonatomic)NSString*dept_type;



-(BOOL)isCompany;
+(unit*)rootUnit;
-(department*)findSubDepartmentByNo:(NSString*)no;
@end
