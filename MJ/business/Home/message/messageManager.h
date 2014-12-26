//
//  messageManager.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "bizManager.h"
#import "MessageTableViewController.h"
#import "person.h"
#import "messageObj.h"


@interface messageManager : bizManager

+(void)getMsgByType:(MJMESSAGETYPE)msgType ListFrom:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;


+(void)sendMessage:(messageObj*)msgObj Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

+(void)setMessage:(messageObj*)msgObj ReadStatus:(MJMESSAGETYPE)status Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
@end
