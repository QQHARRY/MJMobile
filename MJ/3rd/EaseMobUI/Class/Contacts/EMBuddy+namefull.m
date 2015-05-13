//
//  EMBuddy+namefull.m
//  MJ
//
//  Created by harry on 15/5/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "EMBuddy+namefull.h"
#import "EaseMobFriendsManger.h"
#import "person.h"

@implementation EMBuddy (namefull)

-(NSString*)getNamefull
{
    person*psn = [[EaseMobFriendsManger sharedInstance] getFriendByUserName:[self.username uppercaseString]];
    if (psn)
    {
        return psn.name_full;
    }
    else
    {
        return self.username;
    }
}
@end
