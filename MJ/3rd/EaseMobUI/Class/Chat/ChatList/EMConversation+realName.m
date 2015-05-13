//
//  EMConversation+EMConversion_realName.m
//  MJ
//
//  Created by harry on 15/4/30.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "EMConversation+realName.h"
#import "EaseMobFriendsManger.h"


@implementation EMConversation (realName)


-(NSString*)getRealName
{
    if (self.isGroup)
    {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray)
        {
            if ([group.groupId isEqualToString:self.chatter])
            {
                return  group.groupSubject;
            }
        }
    }
    else
    {
        person*psn = [[EaseMobFriendsManger sharedInstance] getFriendByUserName:[self.chatter uppercaseString]];
        if (psn)
        {
            return psn.name_full;
        }
    }

    
    return self.chatter;
}
@end
