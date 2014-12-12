//
//  person.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface person : dic2Object


@property(strong,atomic)NSString*job_no;
@property(strong,atomic)NSString*name_full;
@property(strong,atomic)NSString*company_name;
@property(strong,atomic)NSString*department_name;
@property(strong,atomic)NSString*job_name;
@property(strong,atomic)NSString*obj_mobile;
@property(strong,atomic)NSString*acc_remarks;
@property(strong,atomic)NSString*acc_content;
@property(strong,atomic)NSString*photo;
@property(strong,atomic)NSString*password;

//-(BOOL)initWithDictionary:(NSDictionary*)dic;

+(person*)initMe:(NSDictionary*)dic;
+(person*)me;
+(void)cleanMe;
@end
