//
//  messageManager.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "bizManager.h"
#import "MessageTableViewController.h"
@interface messageManager : bizManager

+(void)getMsgByType:(MJMESSAGETYPE)msgType ListFrom:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
@end
