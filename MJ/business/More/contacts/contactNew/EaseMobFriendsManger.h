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
-(void)addMeToList;

-(void)deleteEMFriends:(NSArray*)friendsArr;
-(void)getFriendByUserName:(NSString*)userName Success:(void (^)(BOOL success,person* psn))success;
-(BOOL)hasFriendWithUserName:(NSString*)userName;
-(void)clean;
@end
