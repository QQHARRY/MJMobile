//
//  EaseMobFriendsManger.h
//  MJ
//
//  Created by harry on 15/5/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bizManager.h"
#import "person.h"

@interface EaseMobFriendsManger : bizManager


+(id)sharedInstance;

-(void)addEMFriends:(NSArray*)friendsArr isFriend:(BOOL)isFriend;
-(void)addEMFriends:(NSArray*)friendsArr isFriend:(BOOL)isFriend WaitForSuccess:(void(^)(BOOL bSuccess))success;
-(void)addMeToList;

-(void)deleteEMFriends:(NSArray*)friendsArr;
-(void)getFriendByUserName:(NSString*)userName Success:(void (^)(BOOL success,person* psn))success;
-(BOOL)hasFriendWithUserName:(NSString*)userName;
-(void)clean;
-(void)initEMFriendsSuccess:(void(^)(BOOL bSuccess))success;
-(void)freshEMFriendsSuccess:(void(^)(BOOL bSuccess))success;

//同步方法,会立即返回，但是如果没有从美嘉服务器获取到好友列表数据，则反悔空
-(person*)getFriendByUserName:(NSString*)userName;
@end
