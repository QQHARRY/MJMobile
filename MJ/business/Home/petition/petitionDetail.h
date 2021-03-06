//
//  petitionDetail.h
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface petitionDetail : NSObject


@property(strong,nonatomic)NSArray*details;
@property(strong,nonatomic)NSArray*historyNodes;
@property(strong,nonatomic)NSDictionary*allDetails;

@property(strong,nonatomic)NSString*chartUrl;
-(BOOL)hasAssistDept;
-(BOOL)isAffordDeptNow;
-(NSString*)nowNodeName;
-(NSString*)assistDepts;
-(NSString*)getID;
-(NSString*)getTaskID;

-(int)getPetitionStatus;
@end
