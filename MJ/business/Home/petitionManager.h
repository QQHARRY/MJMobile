//
//  petitionManager.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bizManager.h"

@interface petitionManager : bizManager

+(void)getListFrom:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;


+(void)getDetailsWithTaskID:(NSString*)taskID PetitionID:(NSString*)PetID Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;


+(void)approveID:(NSString*)id TaskID:(NSString*)taskID ActionType:(int)actionType Reason:(NSString*)reason AssistDepts:(NSArray*)assits Success:(void (^)(id responseObject))success
failure:(void (^)(NSError *error))failure;;
@end
