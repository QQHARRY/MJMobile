//
//  petiotion.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface petiotionBrief : dic2Object

@property(strong,nonatomic)NSString*id;
@property(strong,nonatomic)NSString* taskid;
@property(strong,nonatomic)NSString* reason;
@property(strong,nonatomic)NSString* username;
@property(strong,nonatomic)NSString* userdept;
@property(strong,nonatomic)NSString* flowtype;
@property(strong,nonatomic)NSString* applytime;
@property(strong,nonatomic)NSString* Version;
@property(strong,nonatomic)NSString* task_state;



@end
