//
//  contactDataManager.h
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bizManager.h"
#import "unit.h"

@interface contactDataManager : bizManager

+(unit*)getContactList;

+(void)WaitForDataB4ExpandUnit:(unit*)unt Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;

@end
