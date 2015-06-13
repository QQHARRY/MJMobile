//
//  MJKeywordManager.h
//  MJ
//
//  Created by harry on 15/6/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJKeywordPersistence.h"


#define HOUSE_SEARCH_KW @"houseSearchKeyword"
#define Client_SEARCH_KW @"clientSearchKeyword"


@interface MJKeywordManager : NSObject<MJKeywordPersistence>


+(id<MJKeywordPersistence>)sharedInstance;


@end
