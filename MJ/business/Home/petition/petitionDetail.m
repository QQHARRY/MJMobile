//
//  petitionDetail.m
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petitionDetail.h"

@implementation petitionDetail
@synthesize details;
@synthesize allDetails;
@synthesize historyNodes;
@synthesize chartUrl;


-(BOOL)hasAssistDept
{
    if (self.allDetails && self.allDetails.count > 0)
    {
        NSString*tkey = [allDetails objectForKey:@"flowtype"];
        if (tkey && ([tkey isEqualToString:@"Shop_Affairs"]
                     ||[tkey isEqualToString:@"Department_Affairs"]))
        {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isAffordDeptNow
{
    
    if (self.allDetails && self.allDetails.count > 0)
    {
        NSString*tkey = [allDetails objectForKey:@"tkey"];
        if (tkey && ([tkey isEqualToString:@"department_manager_2"]
            ||[tkey isEqualToString:@"department_manager_3"]))
        {
            return YES;
        }
    }
    return NO;
}

-(NSString*)nowNodeName
{
    if (self.allDetails && self.allDetails.count > 0)
    {
        NSString*tkey = [allDetails objectForKey:@"nowNode"];
        if (tkey && tkey.length > 0)
        {
            return tkey;
        }
    }
    return @"";
}


-(NSString*)assistDepts
{
    
    if (self.allDetails && self.allDetails.count > 0)
    {
        NSString*tkey = [allDetails objectForKey:@"task_performer_no"];
        if (tkey && tkey.length > 0)
        {
            return tkey;
        }
    }
    return @"";
}

-(NSString*)getID
{
    return [allDetails objectForKey:@"id"];
}
-(NSString*)getTaskID
{
    return [allDetails objectForKey:@"taskid"];
}

-(int)getPetitionStatus
{
    NSString* status = [allDetails objectForKey:@"task_status"];
    return [status intValue];
}
@end
