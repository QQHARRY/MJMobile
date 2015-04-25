//
//  person.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "unit.h"
#import <UIKit/UIKit.h>


typedef enum
{
    IM_NOT_OPEN,
    IM_OPENED_NOT_FRIEND,
    IM_FRIEND
    
}IMSTATE;



@interface person : unit


@property(strong,atomic)NSString*job_no;
@property(strong,atomic)NSString*name_full;
@property(strong,atomic)NSString*company_name;
@property(strong,atomic)NSString*department_name;
@property(strong,atomic)NSString*dept_name;
@property(strong,atomic)NSString*job_name;
@property(strong,atomic)NSString*obj_mobile;
@property(strong,atomic)NSString*acc_remarks;
@property(strong,atomic)NSString*acc_content;
@property(strong,atomic)NSString*photo;
@property(strong,atomic)NSString*password;
@property(strong,atomic)NSString*department_no;
@property(strong,atomic)NSString*role_name;
@property(strong,atomic)NSString*technical_post_name;
@property(strong,atomic)NSString*members;

//-(BOOL)initWithDictionary:(NSDictionary*)dic;

+(person*)initMe:(NSDictionary*)dic;
+(person*)me;
+(void)cleanMe;

-(BOOL)isImOpened;
-(IMSTATE)imState:(NSArray*)friendArr;
@end
