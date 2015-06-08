//
//  EaseMobFriendsManger.m
//  MJ
//
//  Created by harry on 15/5/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "EaseMobFriendsManger.h"
#import "EaseMob.h"
#import "person.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "UtilFun.h"
#import "EaseMobContacter.h"



typedef void (^REQUEST_BLOCK)(BOOL success,person* psn);

@interface EaseMobFriendsManger()
{
    
}

@property(strong,nonatomic)NSMutableDictionary*EaseMobFriend;
@property(assign,nonatomic)BOOL initedMe;

@end


@implementation EaseMobFriendsManger

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static EaseMobFriendsManger* mnger = nil;
    dispatch_once(&pred, ^{
        mnger = [[self alloc] init];
        mnger.initedMe = NO;
    });
    return mnger;
}


-(void)addMeToList
{
    if ([person me] && [person me].job_no != nil && [person me].job_no.length != 0)
    {
        EMBuddy*buddy = [EMBuddy buddyWithUsername:[[person me].job_no lowercaseString]];
        
        EaseMobContacter*contact = [[EaseMobContacter alloc] init];
        
        contact.buddy = buddy;
        contact.psn = [person me];
        
        if (_EaseMobFriend == nil)
        {
            _EaseMobFriend = [[NSMutableDictionary alloc] init];
        }
        
        [_EaseMobFriend setObject:contact forKey:[[person me].job_no uppercaseString]];
    }
    
}

-(void)getFriendByUserName:(NSString*)userName Success:(void (^)(BOOL success,person* psn))success
{
    id friend = [_EaseMobFriend objectForKey:[userName uppercaseString]];
    if (friend)
    {
        if (((EaseMobContacter*)friend).psn)
        {
            success(YES,((EaseMobContacter*)friend).psn);
        }
        else
        {
            [((EaseMobContacter*)friend).requestBlock addObject:success];
        }
        
    }
    else
    {
        [self pullFriendsDataFromServer:[self addEMFriendsToList:@[userName] isFriend:NO AndFetchPsn:success] Success:nil];
        
       
    }
    
    
    
}

-(person*)getFriendByUserName:(NSString*)userName
{
    if (userName == nil || userName.length == 0) {
        return nil;
    }
    id friend = [_EaseMobFriend objectForKey:[userName uppercaseString]];
    if (friend)
    {
        if (((EaseMobContacter*)friend).psn)
        {
            person*psn =((EaseMobContacter*)friend).psn;
            if ([psn isKindOfClass:[person class]])
            {
                return psn;
            }
            else
            {
                return nil;
            }
        }
        else
        {
            return  nil;
        }
        
    }
    
    return nil;
}

-(void)addEMFriends:(NSArray*)friendsArr isFriend:(BOOL)isFriend
{
    [self pullFriendsDataFromServer:[self addEMFriendsToList:friendsArr isFriend:isFriend] Success:nil];

}

-(void)addEMFriends:(NSArray*)friendsArr isFriend:(BOOL)isFriend WaitForSuccess:(void(^)(BOOL bSuccess))success
{
    [self pullFriendsDataFromServer:[self addEMFriendsToList:friendsArr isFriend:isFriend] Success:success];
}


-(NSArray*)addEMFriendsToList:(NSArray*)friendsArr isFriend:(BOOL)isFriend
{
    if (!self.initedMe) {
        [self addMeToList];
        self.initedMe = YES;
    }
    NSMutableArray*newFriends = [[NSMutableArray alloc] init];
    (_EaseMobFriend == nil)?(_EaseMobFriend = [[NSMutableDictionary alloc] init]):nil;
    
    for (EMBuddy*buddy in friendsArr)
    {
        NSString*EMName = nil;
        if ([buddy isKindOfClass:[EMBuddy class]])
        {
            EMName = [[buddy username] uppercaseString];
        }
        else if ([buddy isKindOfClass:[NSString class]])
        {
            EMName = [(NSString*)buddy uppercaseString];
        }
        else
        {
            break;
        }
        
        if (EMName != nil && EMName.length > 0)
        {
            id friend = [_EaseMobFriend objectForKey:EMName];
            if (friend == nil)
            {
                EaseMobContacter*contacter = [ [EaseMobContacter alloc] initWithBuddy:buddy Person:nil];
                contacter.isFriend = isFriend;
                [newFriends addObject:EMName];
                [_EaseMobFriend setObject:contacter forKey:EMName];
            }
            else
            {
//                if ([friend isKindOfClass:[EaseMobContacter class]])
//                {
//                    ((EaseMobContacter*)friend).isFriend = isFriend;
//                }
            }
        }
    }
    
    return newFriends;
}


-(NSArray*)addEMFriendsToList:(NSArray*)friendsArr isFriend:(BOOL)isFriend AndFetchPsn:(void(^)(BOOL bSuccess,person*psn))success
{
    if (!self.initedMe) {
        [self addMeToList];
        self.initedMe = YES;
    }
    NSMutableArray*newFriends = [[NSMutableArray alloc] init];
    (_EaseMobFriend == nil)?(_EaseMobFriend = [[NSMutableDictionary alloc] init]):nil;
    
    for (EMBuddy*buddy in friendsArr)
    {
        NSString*EMName = nil;
        if ([buddy isKindOfClass:[EMBuddy class]])
        {
            EMName = [[buddy username] uppercaseString];
        }
        else if ([buddy isKindOfClass:[NSString class]])
        {
            EMName = [(NSString*)buddy uppercaseString];
        }
        else
        {
            break;
        }
        
        if (EMName != nil && EMName.length > 0)
        {
            id friend = [_EaseMobFriend objectForKey:EMName];
            if (friend == nil)
            {
                EaseMobContacter*contacter = [ [EaseMobContacter alloc] initWithBuddy:buddy Person:nil];
                if (success)
                {
                    [contacter.requestBlock addObject:success];
                }
                
                contacter.isFriend = isFriend;
                [newFriends addObject:EMName];
                [_EaseMobFriend setObject:contacter forKey:EMName];
            }
            else
            {
                if ([friend isKindOfClass:[EaseMobContacter class]])
                {
                    ((EaseMobContacter*)friend).isFriend = isFriend;
                }
            }
        }
    }
    
    return newFriends;
}



-(void)deleteEMFriends:(NSArray*)friendsArr
{
    if (friendsArr != nil && friendsArr.count > 0 && _EaseMobFriend != nil  && _EaseMobFriend.count >0 )
    {
        for (EMBuddy*buddy in friendsArr)
        {
            id friend = [_EaseMobFriend objectForKey:[buddy.username uppercaseString]];
            if (friend)
            {
                if ([friend isKindOfClass:[EaseMobContacter class]])
                {
                    ((EaseMobContacter*)friend).isFriend = NO;
                }
                //[_EaseMobFriend removeObjectForKey:[buddy.username uppercaseString]];
            }
        }
    }
}


-(void)pullFriendsDataFromServer:(NSArray*)friendsArr Success:(void(^)(BOOL bSuccess))success
{
    if (friendsArr == nil || [friendsArr count] <= 0)
    {
        if (success)
        {
            success(YES);
        }
        return;
    }
    NSString*friendStrList = [[NSString alloc ]init];
    
    for (NSString* buddyName in friendsArr)
    {
        friendStrList = [NSString stringWithFormat:@"%@%@,",friendStrList,[buddyName uppercaseString]];
    }
    friendStrList = [friendStrList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (friendStrList.length == 0)
    {
        if (success)
        {
            success(YES);
        }
        return;
    }
    
    
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"friends":friendStrList,
                                 @"DeviceType":DEVICE_IOS,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_GET_HX_FRIEND_LIST parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:nil failure:nil ShouldReturnWhenSuccess:NO ])
         {
             [self setPsnToMJFriends:[self getPsnList:resultDic]];
             if (success)
             {
                 success(YES);
             }
         }
     }
                            failure:^(NSError *error)
     {
         if (success)
         {
             success(NO);
         }
     }];
}

-(void)setPsnToMJFriends:(NSArray*)PsnList
{
    for (person*psn in PsnList)
    {
        NSString*name = psn.job_no;
        id friend = [_EaseMobFriend objectForKey:name];
        
        if (friend)
        {
            ((EaseMobContacter*)friend).psn = psn;
            
            NSMutableArray*blockArr =  ((EaseMobContacter*)friend).requestBlock;
            
            for (REQUEST_BLOCK blk  in blockArr)
            {
                blk(YES,psn);
            }
            
            [blockArr removeAllObjects];
        }
    }
}

-(NSArray*)getPsnList:(NSDictionary*)dic
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    NSArray*annArr = [dic objectForKey:@"HxFriendsListNode"];

    
    for (NSDictionary*dic in annArr)
    {
        person* obj = [[person alloc] init];
        [obj initWithDictionary:dic];
        [arr  addObject:obj];
        
    }
    
    return arr;
}

-(void)clean
{
    self.initedMe = NO;
    if(_EaseMobFriend)
    {
        [_EaseMobFriend removeAllObjects];
    }
    

}

-(BOOL)hasFriendWithUserName:(NSString*)userName
{
    if (userName == nil || userName.length ==0)
    {
        return NO;
    }
    
    EaseMobContacter*contacter = [_EaseMobFriend objectForKey:[userName uppercaseString]];
    
    return  contacter != nil && contacter.isFriend == YES;
}


-(void)initEMFriendsSuccess:(void(^)(BOOL bSuccess))success
{
   [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
       
       NSMutableArray*tmpArr = [[NSMutableArray alloc] init];
       for (EMBuddy*buddy in buddyList)
       {
           if (buddy.followState != eEMBuddyFollowState_NotFollowed)
           {
               [tmpArr addObject:buddy];
           }
       }
       
       
        [self addEMFriendsToList:tmpArr isFriend:YES];
       NSArray*arr = [self.EaseMobFriend allKeys];
       
       [self pullFriendsDataFromServer:arr Success:success];
    } onQueue:nil];
    
    
    
    
    
}

-(void)freshEMFriendsSuccess:(void(^)(BOOL bSuccess))success
{
    [self initEMFriendsSuccess:success];
}
@end
