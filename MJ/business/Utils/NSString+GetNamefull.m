//
//  NSString+GetNamefull.m
//  MJ
//
//  Created by harry on 15/6/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "NSString+GetNamefull.h"
#import "person.h"
#import "EaseMobFriendsManger.h"

@implementation NSString (GetNamefull)


-(NSString*)getNamefull
{
    person*psn = [[EaseMobFriendsManger sharedInstance] getFriendByUserName:[self uppercaseString]];
    if (psn)
    {
        return psn.name_full;
    }
    else
    {
        return self;
    }
}



-(void)asynGetNamefull:(void(^)(NSString* namefull))successBlk
{
    [[EaseMobFriendsManger sharedInstance] getFriendByUserName:self Success:^(BOOL success, person *psn) {
        if (psn && successBlk)
        {
            successBlk(psn.name_full);
        }
        else if (successBlk)
        {
            successBlk(self);
        }
    }];
    
}
@end
