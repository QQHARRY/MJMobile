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

@end
